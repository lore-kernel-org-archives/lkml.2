Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0DFS1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:27:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58415 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab0DFS1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:27:41 -0400
Message-ID: <4BBB7AC9.5060008@zytor.com>
Date: Tue, 06 Apr 2010 11:17:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joel Fernandes <agnel.joel@gmail.com>
CC: hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com> <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
In-Reply-To: <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 08:02 AM, Joel Fernandes wrote:
> Hi Hayfeng,
> 
> On Tue, Apr 6, 2010 at 8:07 PM, hayfeng Lee <teklife.kernel@gmail.com> wrote:
>> hello,every one.
>> I have a question:
>> Why does linux choose 896MB to do a start point of ZONE_HIGHMEM and
>> the end point of ZONE_NORMAL. Just for experience?
>> What is the advantages?
> 
> This is not an advantage but a limitation of 32 bit processor and
> architecture. Only physical memory in first 896MB  is directly mapped
> to the kernel virtual memory address space. This is called
> ZONE_NORMAL. To access any physical memory in ZONE_HIGHMEM, the kernel
> has to set up page table entries to indirectly map the physical memory
> into a virtual memory address (I think around 128MB or so worth page
> table entries are reused for this purpose). On the other hand, on 64
> bit architectures, the entire physical memory is directly mapped and
> accessible to the kernel. ZONE_HIGHMEM doesn't exist on 64 bit.
> 
> Take the above with a grain of salt, someone with a better knowledge
> about this intrusive topic can be give a more detailed explanation :)
> 

The ELF ABI specifies that user space has 3 GB available to it.  That
leaves 1 GB for the kernel.  The kernel, by default, uses 128 MB for I/O
mapping, vmalloc, and kmap support, which leaves 896 MB for LOWMEM.

All of these boundaries are configurable; with PAE enabled the user
space boundary has to be on a 1 GB boundary.

	-hpa
