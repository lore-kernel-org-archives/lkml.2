Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249Ab0HEOPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:15:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59928 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759160Ab0HEOPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:15:06 -0400
Message-ID: <4C5AC736.20903@zytor.com>
Date: Thu, 05 Aug 2010 07:14:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Borislav Petkov <bp@amd64.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD machines
References: <1280940316-7966-1-git-send-email-bp@amd64.org> <1280940316-7966-2-git-send-email-bp@amd64.org> <4C59F24B.1010702@zytor.com> <20100805074503.GI18307@amd.com>
In-Reply-To: <20100805074503.GI18307@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 12:45 AM, Roedel, Joerg wrote:
> 
> To make sure I understand correctly, you suggest to initialize
> tramponline_pg_dir in the boot sequence of the first cpu and fork
> swapper_pg_dir from it later on?
> 

Correct.

>> I realize this isn't how the 64-bit code works at the moment, but in a
>> lot of ways I think it would be better if it did.
> 
> Yeah, may make sense. This patch already brings the 32 bit
> implementation closer to the 64 bit one. On 64 bit things are somewhat
> simpler because the tramponline page table can be defined at
> compile-time there (contains only 2 pgd_t entries) while on 32 bit we
> have to initialize it at runtime.

Correct, again.  It's unclear to me if we can get away with the very
simple 64-bit approach -- in particular, not including all the 1:1
mappings in the kernel -- for all future users, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

