Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1EOM1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 08:27:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61269 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab1EOM06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 08:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YcXdHGhBGusYqz3F8HQSiA1t107ssDzg5MDToVpZ3UiAsnrr+KdHWp9K7u0DuX4Y4L
         Xl0YlsI5pWhrbZgXKUQpm4V4WkgUaRM80ki5ofyLOxmUQWZLNRx2tBQyo+HT2+LhCBwp
         5ZyaLFaKjtk11qGt7eVQ1wHDlUAvYuP1RrY0Q=
From: Marek Vasut <marek.vasut@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Zaurus CF tests -- ok
Date: Sun, 15 May 2011 14:26:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-1-amd64; KDE/4.6.1; x86_64; ; )
Cc: Cyril Hrubis <metan@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <20110415211822.GB21111@atrey.karlin.mff.cuni.cz> <20110415213817.GC4420@atrey.karlin.mff.cuni.cz> <20110416074134.GA26440@ucw.cz>
In-Reply-To: <20110416074134.GA26440@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105151426.50230.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 16, 2011 09:41:34 AM Pavel Machek wrote:
> Hi!
> 
> > > After getting _good_ power supply, I was able to untar and rm ltp tree
> > > 100 times so far. 2.6.38, ext3. (So metan no, I do not see any weird
> > > ext3 problems).
> > 
> > Hmm, I'm using original adapter, but who knows if it's okay to use...
> 
> It probably is...
> 
> > > Another strange thing is... I see lots of duplicated keystrokes --
> > > like type "pavel" but machine understands "paavel". But it only seems
> > > to happen when I'm _not_ trying to debug it?!
> > 
> > That seems to be side effect of machine under load (it has gpio
> > keyboard).
> 
> ouch. original corgi_kbd driver used timers, new one uses threads --
> more affected by scheduling. I'm not even sure if the worker thread it
> uses runs at elevated priority...
> 
> > > With power from USB extension cable, it crashes in <5 minutes. It
> > > seems to toggle charger a lot, as voltage on the cable is only
> > > 4.2..4.5V. I guess it is software problem in the charging code.
> > > )
> > 
> > The zaurus actually is AFAIK unable to run from battery when connected to
> > the external power, so weak power line may explain some of the strange
> > behaviour.
> 
> ?? IIRC Stanislav told me that hardware will always run off whatever
> is available...?
> 							Pavel

Backtrace from QEMU ... I think this is what Cyril observed. But heck, it 
happens in QEMU too ;-)

Unable to handle kernel NULL pointer dereference at virtual address 00000000                                                                                                        
pgd = c0004000                                                                                                                                                                      
[00000000] *pgd=00000000                                                                                                                                                            
Internal error: Oops: 17 [#1] PREEMPT                                                                                                                                               
last sysfs file:                                                                                                                                                                    
CPU: 0    Not tainted  (2.6.39-rc5+ #81)                                                                                                                                            
PC is at complete+0x30/0x90                                                                                                                                                         
LR is at giveback+0x134/0x150                                                                                                                                                       
pc : [<c00eca34>]    lr : [<c023c984>]    psr: a0000193                                                                                                                             
sp : c782ff08  ip : c782fec8  fp : c782ff1c                                                                                                                                         
r10: c02b78c4  r9 : c7828720  r8 : c880c000                                                                                                                                         
r7 : c7865828  r6 : c7865894  r5 : c7865828  r4 : a0000113                                                                                                                          
r3 : c782e000  r2 : 00000102  r1 : f2e00000  r0 : 00000000                                                                                                                          
Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel                                                                                                                
Control: 00007977  Table: a5774000  DAC: 00000017                                                                                                                                   
Process ksoftirqd/0 (pid: 3, stack limit = 0xc782e278)                                                                                                                              
Stack: (0xc782ff08 to 0xc7830000)                                                                                                                                                   
ff00:                   60000113 c010497c c786f4d8 c786f4d8 00000000 c023c984                                                                                                       
ff20: c786f4d8 c7868760 c7865878 c023cc28 c786f4d8 60000113 00000000 00000000                                                                                                       
ff40: c02e2980 c02b7a3c 00000000 00000000 00000101 00000008 c02b78c4 c00f4bd8                                                                                                       
ff60: c782e000 00000001 00000018 c02e2980 00000101 c00f5128 c7821660 c782e000                                                                                                       
ff80: c782ffac 00000006 00000000 c782e000 c02e2980 00000000 00000001 00000000                                                                                                       
ffa0: 00000000 00000000 00000000 c00f524c c7823f60 00000000 c782ffd4 c00f51bc                                                                                                       
ffc0: 00000000 c0108d4c c00de570 00000000 00000000 00000000 c782ffd8 c782ffd8                                                                                                       
ffe0: 00000000 c7823f60 c0108cc8 c00de570 00000013 c00de570 00000000 00000000                                                                                                       
[<c00eca34>] (complete+0x30/0x90) from [<c023c984>] (giveback+0x134/0x150)                                                                                                          
[<c023c984>] (giveback+0x134/0x150) from [<c023cc28>] 
(pump_transfers+0x130/0x6f0)                                                                                                  
[<c023cc28>] (pump_transfers+0x130/0x6f0) from [<c00f4bd8>] 
(tasklet_action+0x84/0xdc)                                                                                              
[<c00f4bd8>] (tasklet_action+0x84/0xdc) from [<c00f5128>] 
(__do_softirq+0x74/0x108)                                                                                                 
[<c00f5128>] (__do_softirq+0x74/0x108) from [<c00f524c>] 
(run_ksoftirqd+0x90/0x180)                                                                                                 
[<c00f524c>] (run_ksoftirqd+0x90/0x180) from [<c0108d4c>] (kthread+0x84/0x8c)                                                                                                       
[<c0108d4c>] (kthread+0x84/0x8c) from [<c00de570>] (kernel_thread_exit+0x0/0x8)                                                                                                     
Code: e3c3303f e5932004 e2822001 e5832004 (e5903000)                                                                                                                                
---[ end trace 989a8f1146a65d49 ]---                                                                                                                                                
Kernel panic - not syncing: Fatal exception in interrupt                                                                                                                            
[<c00e2200>] (unwind_backtrace+0x0/0xf0) from [<c024e13c>] (panic+0x70/0x198)                                                                                                       
[<c024e13c>] (panic+0x70/0x198) from [<c00e0c1c>] (die+0x2c8/0x31c)                                                                                                                 
[<c00e0c1c>] (die+0x2c8/0x31c) from [<c00e3350>] (__do_kernel_fault+0x64/0x88)                                                                                                      
[<c00e3350>] (__do_kernel_fault+0x64/0x88) from [<c00e3524>] 
(do_page_fault+0x1b0/0x1c4)                                                                                            
[<c00e3524>] (do_page_fault+0x1b0/0x1c4) from [<c00d72cc>] 
(do_DataAbort+0x34/0x94)                                                                                                 
[<c00d72cc>] (do_DataAbort+0x34/0x94) from [<c00dd1ac>] (__dabt_svc+0x4c/0x60)                                                                                                      
Exception stack(0xc782fec0 to 0xc782ff08)                                                                                                                                           
fec0: 00000000 f2e00000 00000102 c782e000 a0000113 c7865828 c7865894 c7865828                                                                                                       
fee0: c880c000 c7828720 c02b78c4 c782ff1c c782fec8 c782ff08 c023c984 c00eca34                                                                                                       
ff00: a0000193 ffffffff                                                                                                                                                             
[<c00dd1ac>] (__dabt_svc+0x4c/0x60) from [<c00eca34>] (complete+0x30/0x90)                                                                                                          
[<c00eca34>] (complete+0x30/0x90) from [<c023c984>] (giveback+0x134/0x150)                                                                                                          
[<c023c984>] (giveback+0x134/0x150) from [<c023cc28>] 
(pump_transfers+0x130/0x6f0)                                                                                                  
[<c023cc28>] (pump_transfers+0x130/0x6f0) from [<c00f4bd8>] 
(tasklet_action+0x84/0xdc)                                                                                              
[<c00f4bd8>] (tasklet_action+0x84/0xdc) from [<c00f5128>] 
(__do_softirq+0x74/0x108)                                                                                                 
[<c00f5128>] (__do_softirq+0x74/0x108) from [<c00f524c>] 
(run_ksoftirqd+0x90/0x180)                                                                                                 
[<c00f524c>] (run_ksoftirqd+0x90/0x180) from [<c0108d4c>] (kthread+0x84/0x8c)                                                                                                       
[<c0108d4c>] (kthread+0x84/0x8c) from [<c00de570>] (kernel_thread_exit+0x0/0x8)
