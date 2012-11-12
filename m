Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab2KLMdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:33:46 -0500
Received: from mail.agmk.net ([91.192.224.71]:53862 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab2KLMdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:33:45 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: Re: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule)
Date: Mon, 12 Nov 2012 13:33:39 +0100
Message-ID: <3023364.Bjpo0brdul@pawels>
User-Agent: KMail/4.9.1 (Linux/3.6.6; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1539324.MIArxLN8tE@pawels>
References: <56378024.A3Kec8xZj0@pawels> <50A0A7EF.3050706@linux.vnet.ibm.com> <1539324.MIArxLN8tE@pawels>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 of November 2012 11:22:47 Paweł Sikora wrote:
> On Monday 12 of November 2012 15:40:31 Michael Wang wrote:
> > On 11/12/2012 03:16 PM, Paweł Sikora wrote:
> > > On Monday 12 of November 2012 11:04:12 Michael Wang wrote:
> > >> On 11/09/2012 09:48 PM, Paweł Sikora wrote:
> > >>> Hi,
> > >>>
> > >>> during playing with new ups i've caught an nice oops on reboot:
> > >>>
> > >>> http://imgbin.org/index.php?page=image&id=10253
> > >>>
> > >>> probably the upstream is also affected.
> > >>
> > >> Hi, Paweł
> > >>
> > >> Are you using a clean 3.6.6 without any modify?
> > > 
> > > yes, pure 3.6.6 form git tree with modular config.
> > > 
> > >> Looks like some threads has set itself to be UNINTERRUPTIBLE with out
> > >> any design on switch itself back later(or the time is too long), are you
> > >> accidentally using some bad designed module?
> > > 
> > > hmm, hard to say. mostly all modules are loaded automatically by kernel.
> > 
> > Could you please provide the whole dmesg in text? your picture lost the
> > print info of the hung task.
> 
> i've grabbed the console via rs232 but there's no more info (see attached txt).

hmm, i have one observation.

during rc.shutdown there're messages on console like this: Cannot stat file /proc/$pid/fd/1: Connection timed out
afaics this file descriptor points to vnc log file on a remote machine, e.g.:

# ps aux|grep xfwm4
eda       1748  0.0  0.0 320220 11224 ?        S    13:08   0:00 xfwm4 

# readlink -m /proc/1748/fd/1
/remote/dragon/ahome/eda/.vnc/odra:11.log

# mount|grep ahome
dragon:/home/users/ on /remote/dragon/ahome type nfs (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,soft,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.0.2.121,mountvers=3,mountport=45251,mountproto=udp,local_lock=none,addr=10.0.2.121)


so, probably during `killall5 -TERM/-KILL` on shutdown stage something sometimes go wrong
and these processes (xfce4/vncserver) survive the signal and hang on the nfs i/o.

BR,
Paweł.

