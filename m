Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab2HXQ1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:27:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52009 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759830Ab2HXQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:26:58 -0400
Date: Fri, 24 Aug 2012 18:26:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        andi@firstfloor.org
Subject: Re: [PATCH] perf/x86: fix microcode revision check for SNB-PEBS
Message-ID: <20120824162646.GE2297@aftab.osrc.amd.com>
References: <20120824133434.GA8014@quad>
 <20120824160838.GC2297@aftab.osrc.amd.com>
 <CABPqkBRV=2k34yfnr_y0fpftWab6YN2Q=qDKqA5xAW-R-r1bHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRV=2k34yfnr_y0fpftWab6YN2Q=qDKqA5xAW-R-r1bHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 06:14:51PM +0200, Stephane Eranian wrote:
> So you're saying there is a cmdline tool that can use another
> interface to pass the ucode to the kernel. I am using the
> microcode_ctl on Ubuntu 11.04. Apparently that one is still using the
> old interface. But I may not be the only one in this situation then,
> so I think it's worth fixing now.
>
> What's the tool to update the ucode using the "new" interface then?

Well,

last time we talked about it:
http://marc.info/?l=linux-kernel&m=134012203712243 I was advocating the
following way:

Put ucode image into /lib/firmware/amd-ucode or /lib/firmware/intel-ucode and then do

$ echo 1 > /sys/devices/system/cpu/microcode/reload

which I think is the easiest but hpa had some reservations about it and
wanted to keep the old method too.

But looking at the code, this *actually* should work on Intel now too.

So, I'd say you can use both on Intel, it depends on them whatever they
decide to do in the future.

On AMD we have only the "echo 1" thing.

Alternatively, "rmmod microcode; modprobe microcode" works too but some
people wouldn't want to reload modules in order to update ucode.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
