Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2EHUmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:42:47 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34143 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2EHUmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:42:46 -0400
Message-ID: <1336509763.7416.30.camel@lorien2>
Subject: Re: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul
 cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Ingo Molnar <mingo@kernel.org>
Cc: shuahkhan@gmail.com, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@redhat.com, tglx@linutronix.de, tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 08 May 2012 14:42:43 -0600
In-Reply-To: <20120508040009.GB30652@gmail.com>
References: <1336324264.2897.9.camel@lorien2>
	 <20120507104943.GA3896@x1.osrc.amd.com> <4FA815E3.1030101@zytor.com>
	 <20120507211612.GA19700@liondog.tnic>
	 <20120508012341.GA27000@khazad-dum.debian.net>
	 <20120508040009.GB30652@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 06:00 +0200, Ingo Molnar wrote:
> * Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> 
> > > Of course, one can iterate over each core in a shell-loop 
> > > and write into the reload file to reload ucode after having 
> > > updated the ucode image in /lib/firmware but removing and 
> > > then modprobing the module is shorter :-)
> > 
> > Can we PLEASE fix it properly by adding a new node (which is 
> > _not_ per-cpu) that requests the microcode core to refresh all 
> > cpus?  Preferably by invalidating the microcode cache, THEN 
> > fetching each required microcode just once for the first core 
> > that needs it, and caching it for use the other cores.  You 
> > can leave the (IMHO mostly useless) per-cpu sysfs nodes alone, 
> > so as to not break ABI, or deprecate them for an year or 
> > something.
> > 
> > I am speaking this with my userland maintainer hat.  I *do 
> > NOT* want to rmmod crap in a production server to update 
> > microcode.  And I want to be able to support static-compiled 
> > microcode.
> 
> Seconded. There's also the ability to disable module unloading.

I will take a stab at the disabling module unloading if I may. The rest
of the tasks are a bit out of my league at this time. :)

Thanks,
-- Shuah


