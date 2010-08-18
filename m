Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0HRUFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:05:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36423 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab0HRUFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:05:05 -0400
Message-ID: <4C6C3CBA.8090504@zytor.com>
Date: Wed, 18 Aug 2010 13:04:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 2/2] x86, cpu hotplug: Fix cpu bringup concurrency
 issue
References: <4C5AC736.20903@zytor.com> <20100812144142.GY23755@8bytes.org> <4C64148D.5080305@zytor.com> <20100812170644.GZ23755@8bytes.org> <4C644507.9020606@zytor.com> <20100812190414.GA23755@8bytes.org> <20100813123543.GC9046@aftab> <20100816121933.GA28147@aftab> <20100816123959.GC28147@aftab> <4C6C2E85.9050401@zytor.com> <20100818192858.GC12842@aftab>
In-Reply-To: <20100818192858.GC12842@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 12:28 PM, Borislav Petkov wrote:
>>
>> warning: (X86) selects ARCH_CPU_PROBE_RELEASE which has unmet direct
>> dependencies (HOTPLUG_CPU)
> 
> well I got 
> 
> +config ARCH_CPU_PROBE_RELEASE
> +       def_bool y
> +       depends on HOTPLUG_CPU
> 
> but I guess ARCH_CPU_PROBE_RELEASE gets selected still. Why isn't that
> "depends on" forcing it, I guess select is stronger.
> 
>> ... and build failure when compiling without CONFIG_HOTPLUG_CPU.
> 
> This hunk fixes the !CONFIG_HOTPLUG_CPU build here but I should've
> caught it earlier, shame on me. Sorry for the inconvenience, can you
> please drop this second patch for now, I'll send you a revised version
> tomorrow.
> 

I would prefer to not continue to have a piece of Kconfig code which
warns, so I'll hold off on this until I have your revised patch.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

