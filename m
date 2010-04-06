Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0DFUP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:15:56 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:35180 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0DFUPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KKa3HOPqzssG0J5hcszUbv3SIIUEqqVITwhJ2yf1ce3afcHhEA4Yd9JfpjgD7hmIjA
         rUYzIdPiAROwSU8k8otZP1QZejERKmzVWBiaTv874PngK7Izw59Xv/0i4M7hkxJvBauR
         11Htg1nio3jLY/AwOC3HwmY6mGkDM/TGRlW6I=
MIME-Version: 1.0
In-Reply-To: <4BBB8F07.60401@zytor.com>
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
	 <4BBB7AC9.5060008@zytor.com>
	 <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
	 <4BBB8F07.60401@zytor.com>
Date: Tue, 6 Apr 2010 13:15:49 -0700
Message-ID: <p2q8f84f9951004061315z7d2be34aj41b5052cf20879f3@mail.gmail.com>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
From: Frank Hu <frank.hu.2001@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joel Fernandes <agnel.joel@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 12:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/06/2010 12:20 PM, Frank Hu wrote:
>>>
>>> The ELF ABI specifies that user space has 3 GB available to it.  That
>>> leaves 1 GB for the kernel.  The kernel, by default, uses 128 MB for I/O
>>> mapping, vmalloc, and kmap support, which leaves 896 MB for LOWMEM.
>>>
>>> All of these boundaries are configurable; with PAE enabled the user
>>> space boundary has to be on a 1 GB boundary.
>>>
>>
>> the VM split is also configurable when building the kernel (for 32-bit
>> processors).
>
> I did say "all these boundaries are configurable".  Rather explicitly.
>
>        -hpa
>

thought that you can only configure how to split the VM like 1G/3G or
2G/2G. But the DMA zone size, the 128MB space for I/O is not
configurable. The NORMAL zone size will be deducted based on the VM
Split and some hard coded DMA zone and 128 MB space size.

I am not a guru in this space... so I might be wrong.
