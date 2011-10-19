Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1JSNFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:05:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47390 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1JSNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:05:37 -0400
Message-ID: <1319029529.8416.3.camel@edumazet-laptop>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Wed, 19 Oct 2011 15:05:29 +0200
In-Reply-To: <4E9EC96E.8020303@broadcom.com>
References: <20111019123602.GA11883@schottelius.org>
	 <1319028563.8416.1.camel@edumazet-laptop> <4E9EC96E.8020303@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 19 octobre 2011 à 14:58 +0200, Arend van Spriel a écrit :
> On 10/19/2011 02:49 PM, Eric Dumazet wrote:
> > Le mercredi 19 octobre 2011 à 14:36 +0200, Nico Schottelius a écrit :
> >> Hello,
> >>
> >> I've
> >>
> >> Eric Dumazet [Tue, Oct 18, 2011 at 02:24:25PM +0200]:
> >>> Must be a mutex_unlock(some_mltex) missing somewhere.
> >>>
> >>> Then later, a process holding RTNL is blocking on mutex_lock(some_mutex)
> >>>
> >>> Try a "CONFIG_LOCKDEP=y" enabled build
> >>
> >> Did so, attached is the dmesg output after 3x suspend.
> >>
> >> It also seems this bug gets more / only triggered when I loose the
> >> connection to a wpa2-eap network that is defined like this:
> >>
> >> network={
> >>    ssid="eth"
> >>   id_str="eth-802.2x"
> >>    key_mgmt=WPA-EAP
> >>    proto=WPA2
> >>    eap=TTLS
> >>    pairwise=CCMP TKIP
> >>    group=CCMP TKIP
> >>    phase2="auth=MSCHAPV2"
> >>    identity="MYNAME"
> >>    password="forgottoremoveit"
> >> }
> >>
> >> Hope the dmesg output helps and we can remove the problem soon
> >> and making the mba finally almost completly usable :-)
> >>
> > 
> > Sorry, no CONFIG_LOCKDEP in your config or dmesg. Maybe you sent a
> > previous dmesg/config file ?
> > 
> > Note that you have "CONFIG_LOCKDEP_SUPPORT=y", not "CONFIG_LOCKDEP=y"
> > 
> 
> Hi Eric,
> 
> Are there any configuration setting needed that CONFIG_LOCKDEP depends on?



config LOCKDEP
        bool
        depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
        select STACKTRACE
        select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE
        select KALLSYMS
        select KALLSYMS_ALL

make menuconfig
 -> Kernel hacking
   -> Lock debugging: prove locking correctness



