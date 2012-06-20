Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2FTXtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:49:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42909 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab2FTXtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:49:00 -0400
Message-ID: <4FE26155.8030207@zytor.com>
Date: Wed, 20 Jun 2012 16:48:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
References: <1340121811-4477-3-git-send-email-bp@amd64.org> <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com> <20120619232857.GH5996@aftab.osrc.amd.com> <1340182778.21745.75.camel@twins> <20120620230856.GA4223@khazad-dum.debian.net> <4FE2585A.3000505@zytor.com> <20120620232359.GD2016@aftab.osrc.amd.com> <4FE25C7E.9030109@zytor.com> <4FE25DF9.2020305@zytor.com> <20120620234611.GA3440@aftab.osrc.amd.com>
In-Reply-To: <20120620234611.GA3440@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 04:46 PM, Borislav Petkov wrote:
>>
>> Except you still need to re-poke it when you have a new microcode
>> blob... so what was gained by all this churn?
> 
> We need to do that anyway if new (F,M,S) ucode piece comes along.
> 
> The gain is twofold:
> 
> * we don't need the userspace tool to split the blob - we have one
> single file we load and the driver picks out what it needs.
> 
> * as a result, we drop the CONFIG_MICROCODE_OLD_INTERFACE, i.e.
> /dev/cpu/microcode which takes the single blob anyway which the driver
> picks apart later.
> 
> In the end, we have one unified ucode loading procedure:
> 
> 1. put the blob in /lib/firmware/...
> 2. echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> That's it - it can't be simpler than that.
> 

I really don't get why the whole thing is any simpler than the old
/dev/cpu/microcode interface in the first place, where instead of:

> 1. put the blob in /lib/firmware/...
> 2. echo 1 > /sys/devices/system/cpu/microcode/reload

... you do ...

1. dd if=<microcode blob> of=/dev/cpu/microcode bs=<large>

... as well as set up the early initramfs part, of course.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

