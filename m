Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab0HLTCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:02:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58465 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0HLTCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:02:20 -0400
Message-ID: <4C644507.9020606@zytor.com>
Date: Thu, 12 Aug 2010 12:01:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Borislav Petkov <bp@amd64.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD	machines
References: <1280940316-7966-1-git-send-email-bp@amd64.org> <1280940316-7966-2-git-send-email-bp@amd64.org> <4C59F24B.1010702@zytor.com> <20100805074503.GI18307@amd.com> <4C5AC736.20903@zytor.com> <20100812144142.GY23755@8bytes.org> <4C64148D.5080305@zytor.com> <20100812170644.GZ23755@8bytes.org>
In-Reply-To: <20100812170644.GZ23755@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 10:06 AM, Joerg Roedel wrote:
> On Thu, Aug 12, 2010 at 08:34:37AM -0700, H. Peter Anvin wrote:
> 
>> Agreed.  I do have a concern about the kernel page tables not being
>> synchronized into trampoline_pg_dir (it's only an issue for 32-bit
>> !PAE), so at the very least we need to keep an eye out for it...
> 
> Great.
> 
> The synchronization problem might be real. The cpu_init function uses
> per-cpu variables which might not be present in the early synced
> tramponline page table (iirc). The change to swapper_pg_dir and the
> global tlb flush should probably be moved to the very beginning of the
> start_secondary function.
> 

Are you going to submit an updated patch, then?

	-hpa

