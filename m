Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0HRSmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:42:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49614 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0HRSmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:42:09 -0400
Message-ID: <4C6C294D.3030404@zytor.com>
Date: Wed, 18 Aug 2010 11:41:17 -0700
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
Subject: Re: [PATCH -v2 1/2] x86-32: Fix crashes with CPU hotplug on AMD machines
References: <4C59F24B.1010702@zytor.com> <20100805074503.GI18307@amd.com> <4C5AC736.20903@zytor.com> <20100812144142.GY23755@8bytes.org> <4C64148D.5080305@zytor.com> <20100812170644.GZ23755@8bytes.org> <4C644507.9020606@zytor.com> <20100812190414.GA23755@8bytes.org> <20100813123543.GC9046@aftab> <20100816121933.GA28147@aftab> <20100816123833.GB28147@aftab>
In-Reply-To: <20100816123833.GB28147@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 05:38 AM, Borislav Petkov wrote:
>  #else
>  static inline void reserve_trampoline_memory(void) {};
> +extern void __init setup_trampoline_page_table(void) {};
>  #endif /* CONFIG_X86_TRAMPOLINE */

This breaks compilation in the !CONFIG_X86_TRAMPOLINE case; I presume
you meant:

static inline void setup_trampoline_page_table(void) {}

... here too?

(No semicolon after a function body!)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

