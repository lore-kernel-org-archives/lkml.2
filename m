Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0KDOiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:38:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38479 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0KDOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vMrRy50uM7x7DwLHOmMPfsDMrYiIYUgVMPMpkGgLXuw0I9AJHSr83Zg1+Bhr/8hG7f
         93Tojf/ONnGugxjc+YrQLvAlfdee7PIzpnbIiuJyQQhtiQbnN78aVSj2aICWZXjyF9ec
         kys90GsT471zpebE5tqGhUv2M/mevXuu32nH4=
Subject: Re: divide error in select_task_rq_fair()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101104142853.GA11656@helgaas.com>
References: <20101104041236.GA9389@helgaas.com>
	 <1288847992.2718.37.camel@edumazet-laptop>
	 <20101104142853.GA11656@helgaas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 15:37:54 +0100
Message-ID: <1288881474.2659.123.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 08:28 -0600, Bjorn Helgaas a écrit :
> On Thu, Nov 04, 2010 at 06:19:52AM +0100, Eric Dumazet wrote:
> > Le mercredi 03 novembre 2010 à 22:12 -0600, Bjorn Helgaas a écrit :
> > > Hi,
> > > 
> > > With current upstream, I see the following crash at boot-time:
> > > 
> > >     Brought up 64 CPUs
> > >     Total of 64 processors activated (289366.52 BogoMIPS).
> > >     divide error: 0000 [#1] SMP 
> > >     last sysfs file: 
> > >     CPU 1 
> > >     Modules linked in:
> > > 
> > >     Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-00027-gff8b16d #271 /ProLiant DL980 G7
> > >     RIP: 0010:[<ffffffff81034645>]  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
> > > 
> > > Complete dmesg below; let me know if you need more info.
> > 
> > Is the machine runs OK if you build a kernel with NR_CPUS=128 ?
> 
> Nope, it fails the same way with NR_CPUS=128.  Dmesg below.

Sorry, just try 256 or 512, it seems you have a pretty big machine ?

8 nodes, but only nodes from 0-3 are populated.



