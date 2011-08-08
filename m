Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1HHWOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:14:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50346 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1HHWON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:14:13 -0400
Message-ID: <4E405F7D.9000701@zytor.com>
Date: Mon, 08 Aug 2011 17:13:17 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd64.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC][PATCH 2/2] x86, cpu, amd: Add a per-vendor BSP function
References: <1312829872-20260-1-git-send-email-bp@amd64.org> <1312829872-20260-3-git-send-email-bp@amd64.org> <4E404D68.5060507@zytor.com> <20110808215713.GB22088@liondog.tnic>
In-Reply-To: <20110808215713.GB22088@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 04:57 PM, Borislav Petkov wrote:
>>
>> This is totally going backwards.  We *should* be using struct cpu_dev
>> rather than switch statements for this.
> 
> Right, but all the cpu_dev things are annotated with __cpuinitconst
> because they're used in CONFIG_HOTPLUG_CPU. __init, OTOH, will be
> discarded once we're done booting. So, we can't convert cpu_dev
> to __initdata because we need it for cpu hotplug and we want the
> run_on_bsp() functionality to be __init since it runs once on boot.
> 
> Maybe leave cpu_dev in __cpuinit let it have an __init member which is
> the ->run_on_bsp()? Does that even work?
> 

I don't think so, which is a fundamental shortcoming of our way of
handling these kinds of pointers.  One way to deal with it would be to
make struct cpu_dev __initconst and copy it into a __cpuinit variable at
init time.

Either way, I'd rather leave the routines in cpuinit memory than adding
another multiplex.

	-hpa

