Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973Ab2EHEAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:00:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40830 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2EHEAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:00:16 -0400
Date: Tue, 8 May 2012 06:00:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuahkhan@gmail.com>, mingo@redhat.com, tglx@linutronix.de,
        tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul
 cleanup
Message-ID: <20120508040009.GB30652@gmail.com>
References: <1336324264.2897.9.camel@lorien2>
 <20120507104943.GA3896@x1.osrc.amd.com>
 <4FA815E3.1030101@zytor.com>
 <20120507211612.GA19700@liondog.tnic>
 <20120508012341.GA27000@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508012341.GA27000@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> > Of course, one can iterate over each core in a shell-loop 
> > and write into the reload file to reload ucode after having 
> > updated the ucode image in /lib/firmware but removing and 
> > then modprobing the module is shorter :-)
> 
> Can we PLEASE fix it properly by adding a new node (which is 
> _not_ per-cpu) that requests the microcode core to refresh all 
> cpus?  Preferably by invalidating the microcode cache, THEN 
> fetching each required microcode just once for the first core 
> that needs it, and caching it for use the other cores.  You 
> can leave the (IMHO mostly useless) per-cpu sysfs nodes alone, 
> so as to not break ABI, or deprecate them for an year or 
> something.
> 
> I am speaking this with my userland maintainer hat.  I *do 
> NOT* want to rmmod crap in a production server to update 
> microcode.  And I want to be able to support static-compiled 
> microcode.

Seconded. There's also the ability to disable module unloading.

Thanks,

	Ingo
