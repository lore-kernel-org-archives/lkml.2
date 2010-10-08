Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0JHALJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:11:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50550 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0JHALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:11:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57115947"
Message-ID: <4CAE619A.2050302@codeaurora.org>
Date: Thu, 07 Oct 2010 17:11:06 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org> <1285644827-6846-2-git-send-email-sboyd@codeaurora.org> <1286299355.18791.11.camel@c-dwalke-linux.qualcomm.com> <4CABEECB.4030301@codeaurora.org> <alpine.LFD.2.00.1010061024220.3107@xanadu.home> <4CACC053.2090509@codeaurora.org> <1286393743.22265.129.camel@m0nster> <alpine.LFD.2.00.1010061553350.3107@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1010061553350.3107@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/06/2010 01:05 PM, Nicolas Pitre wrote:
> You could use the noinline qualifier from <linux/compiler.h> with those 
> functions you don't want inlined.
>

That won't help me for the interleaving behavior though.

>> Is it possible to do all this in assembly ? Can't you have the default
>> implementation using this assembly with different function names, then
>> just set the assembly function names in C code someplace?
> That weould be my preference too.  Being in assembly means that this 
> code is unlikely to change with different optimization levels and/or gcc 
> versions which would otherwise require different calibration values. 
> Relying on stable calibration is necessary for the lpj kernel cmdline 
> parameter to have some meaning.

Why doesn't any other architecture use assembly for their lpj code? They
may use headers with assembly in them or C code with assembly in them,
but they don't write all of the delay code in assembly and rely on
function interleaving. This leads me to believe other arches aren't
concerned about compiler optimizations breaking lpj cmdline parameters,
so why should ARM be concerned?

I tested the theory out and scaled down the CPU frequency to 19.2 MHz
and then called calibrate_delay(). Before and after applying this series
I got the same results.

Calibrating delay loop... 12.67 BogoMIPS (lpj=63360)

Jumping up to 1.2 GHz and calling calibrate_delay() gives me the same
before and after

Calibrating delay loop... 792.98 BogoMIPS (lpj=3964928)

I don't have access to a machine capable of running slower than 19.2
MHz. Maybe machines running in the KHz range would experience differences?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

