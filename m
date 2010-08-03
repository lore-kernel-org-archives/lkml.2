Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0HCC3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:29:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53391 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab0HCC3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:29:39 -0400
Message-ID: <4C577EFA.4070003@zytor.com>
Date: Mon, 02 Aug 2010 19:29:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Konrad Rzeszutek <konrad@hera.kernel.org>, torvalds@linux-foundation.org,
        James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
        pjones@redhat.com, lenb@kernel.org, michaelc@cs.wisc.edu,
        mcb30@ipxe.org
Subject: Re: [GIT PULL] iBFT features for v2.6.36
References: <20100802143642.GA15428@hera.kernel.org> <20100802195248.GB32503@andromeda.dapyr.net> <4C572A13.4010303@zytor.com> <201008022108.04024.konrad@kernel.org>
In-Reply-To: <201008022108.04024.konrad@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 06:08 PM, Konrad Rzeszutek Wilk wrote:
> 
> Can you point me what 'standard ACPI mechanism' is? Like sticking the code in 
> the drivers/acpi ? And then having a generic driver to handle the 
> [i,a,s,m]BFT tables and maybe some subordinate ones for specific pieces where 
> the generic can't handle it?
> 

With the standard ACPI mechanism I meant RDSP -> {RSDT,XSDT} -> table.
If it was easily possible to add SSDTs to this table structure then
probably the best thing would have been to make them PnP devices.

>>>> It would be good to have some kind of common structure framework for
>>>> these.
>>>
>>> I need to grok those tables some more to figure out what they all do.
>>
>> More or less the same thing as iBFT, but for AoE, SRP, or in-memory disk.
> 
> What is the tools state ? For iBFT, iscsi-initiator-utils scans 
> the /sys/firmware directory to extract the relevant data and does its thing. 
> Are there tools for AoE, SCSI RDMA Protocol (SRP), and in-memory disk?

I don't know about AoE and SRP (Michael Brown <mcb30@ipxe.org> would
know), but I have a tool which scans for mBFT directly out of /dev/mem,
which is of course kind of ugly.  It's shipped with the Syslinux
distribution in the utils/ directory.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

