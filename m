Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1BTEom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:44:42 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:26703 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab1BTEom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:44:42 -0500
X-Loopcount0: from 143.166.82.43
Date: Sat, 19 Feb 2011 22:44:40 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
        San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110220044440.GA28167@auslistsprd01.us.dell.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com> <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com> <20110125031752.GA9846@kroah.com> <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com> <20110126024608.GB28283@kroah.com> <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com> <AANLkTimT_t-3smsaQUrtisFdkODfoOoroQ93tQ9PByBq@mail.gmail.com> <AANLkTim27Y+TKa54jhC1VuqXzjEzX150ysGoUKNJrBmk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim27Y+TKa54jhC1VuqXzjEzX150ysGoUKNJrBmk@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 03:41:06PM -0800, Mike Waychison wrote:
> On Wed, Jan 26, 2011 at 5:22 PM, Mike Waychison <mikew@google.com> wrote:
> 
> I've spent the last few hours looking at efivars.c and working out how
> I can refactor it to reuse all the kobject bits it uses.  Does anybody
> use this thing though?
> 
> I can't believe I was just lectured for crappy ABI when this thing
> takes a binary packed struct on write() and process it:
>    - without regard to write length, and
>    - in a way that isn't compatible across compat (both DataSize and
> Status are unsigned long!).
> 
> struct efi_variable {
>         efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
>         efi_guid_t    VendorGuid;
>         unsigned long DataSize;
>         __u8          Data[1024];
>         efi_status_t  Status;
>         __u32         Attributes;
> } __attribute__((packed));
> 
> :(

I wrote that long before anyone believed there could be a 32-bit EFI
or 32-bit kernel running on a 64-bit EFI.  Remember, this originated
on Itanium.  I knew it was ugly, but the EFI spec itself defined the
DataSize and Status as they did.

-- 
Matt Domsch
Technology Strategist
Dell | Office of the CTO
