Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2K2MgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:36:15 -0500
Received: from mail.vapor.com ([83.220.149.2]:54931 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2K2MgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:36:14 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2012 07:36:14 EST
Date: Thu, 29 Nov 2012 13:27:08 +0100
From: Ian Kumlien <pomac@vapor.com>
To: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
Message-ID: <20121129122708.GA6365@pomac.netswarm.net>
References: <1354144802.5396.3.camel@pi>
 <20121129092621.GA21100@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129092621.GA21100@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:26:21AM +0100, Borislav Petkov wrote:
> On Thu, Nov 29, 2012 at 12:20:02AM +0100, Ian Kumlien wrote:
> > Hi, 
> > 
> > Due to unexplained dns problems, I'll be using google plus to post the
> > photo of the bug output.
> > 
> > https://plus.google.com/photos/110698868656495230656/albums/5816005854482735041
> > 
> > I'm sorry but my knowledge is limited and current caffeine level is low,
> > so I'm offloading to someone who has these things handled ;)
> 
> Hmm, this looks strange, were you doing any system tracing or similar?

I think that chrome does traceing all the time as a part of it's sandbox
- this is most likely chrome monitoring flash... 

> How reproducible is this? If you can reliably reproduce it, can you
> make a much more readable screen photo of it so that one can read all
> register values and the "Code:" section in the backtrace is complete and
> also readable?

I can't say, it's the first kernel bug i have in quite a while - I guess
time will tell.

It seems like google plus worsened the image quality and i had another
picture to go by as well, so i peiced them together in to the following
information - Now if i just had the energy to disable the wraparound in
vim.... 

---

BUG: unable to handle kernel NULL pointer dereference at
0000000000000063
IP: [<ffffffff8100b64b>] syscall_trace_enter+0x15e/0x191
PGD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: snd_usb_audio snd_usbmidi_lib nouveau mxm_wmi wmi
i2x_algo_bit ttm drm_kms_helper drm
CPU 0
Pid: 24590, comm: chrome Not tainted 3.7.0-rc7 #50 System manufacturer
System Product Name/A8N32-SLI-Deluxe
RIP: 0010:[<ffffffff8100b64b>] [<ffffffff8100b64b>]
syscall_trace_enter+0x15e/0x191
RSP: 0018:ffff8800058e3f38 EFLAGS: 00010206
RAX: 0000000000000081 RBX: ffff8800058e3f58 RCX: 0000000000000063
RDX: 00007fe1f2fbde18 RSI: 00000000000000ca RDI: 00007fe1f2fbde18
RBP: 0000000000000000 R08: 0000000000000001 R09: 00007fe23f9fcb10
R10: 00007fe23f9fcb10 R11: 0000000000000206 R12: 0000000000000032
R13: 00007fe23f9fd9c0 R14: 00007fe25d743710 R15: 0000000000000007
FS:  00007fe23f9fd700(0000) GS:ffff88013fc00000(0000)
knlGS:00000000f5c88740
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000063 CR3: 0000000083a84000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process chrome (pid: 24590, threadinfo ffff8800058e2000, task
ffff88003dacd3b0)
Stack:
 00007fe1f2fbde10 0000000000000001 0000000000000032 ffffffff8160646c
 0000000000000007 00007fe25d743710 00007fe23f9fd9c0 0000000000000032
 0000000000000001 00007fe1f2fbde10 0000000000000206 00007fe23f9fcb10
Call Trace:
 [<ffffffff8160646c>] ? tracesys+0x7e/0xe2
Code: 53 28 48 85 ff 74 29 83 3f 00 75 24 eb 37 65 48 8b 0c 25 80 b8 00
00 48 8b 89 c0 04 00 00 4c 8b 4b 38 48 8b 53 70 48 85 c9 74 08 <83> 39
00 74 1f 48 83 ca ff 48 85 ed 75 04 48 8b 53 78 5b 5d 48
RIP  [<ffffffff8100b64b>] syscall_trace_eneter+0x15e/0x191
 RSP <ffff8800058e3f38>
CR2: 0000000000000063

---

> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
