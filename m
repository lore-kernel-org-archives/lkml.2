Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2LKUQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:16:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41850 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab2LKUQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:16:52 -0500
Date: Tue, 11 Dec 2012 21:16:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?RnLDqWTDqXJpYyBMLiBXLg==?= Meunier <fredlwm@fredlwm.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup with 3.7.0 but not 3.6.10
Message-ID: <20121211201647.GD8873@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?RnLDqWTDqXJpYyBMLiBXLg==?= Meunier <fredlwm@fredlwm.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20121211213636.GA19943@pervalidus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121211213636.GA19943@pervalidus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 07:36:36PM -0200, Frédéric L. W. Meunier wrote:
> While compiling MPlayer git on 3.7.0, I noticed the attached messages. I 
> then compiled 3.6.10, without any message being printed by the kernel, 
> and thought it could be due to MPlayer being compiled on tmpfs, while 
> the kernel on ext4. But compiling MPlayer on ext4 didn't change 
> anything.
> 
> I booted on 3.6.10 and couldn't reproduce it.
> 
> According to 'free', swap isn't used at all during the compilation.
> 
> I'm also attaching my .config.
> 
> It's an Athlon 64 X2 Dual Core Processor 4000+ with 2Gb of DDR2.

What family is that? Can you give /proc/cpuinfo?

> Dec 11 16:02:15 pervalidus kernel: [11260.096015] BUG: soft lockup - CPU#1 stuck for 22s! [cc1:20906]

Hmm, this says that gcc gets stuck at some point. Is this always
reproducible on 3.7?

What about using another version of gcc, can you repro it then too?

It would be interesting to know where all those cc1 processes get stuck.
Can you break into them with gdb and dump the code around RIP everytime
those tasks gets stuck? Try doing a couple of them to see whether it is
repeatable.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
