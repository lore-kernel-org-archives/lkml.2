Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2HaAmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:42:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2HaAmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:42:10 -0400
Message-ID: <50400859.2080606@canonical.com>
Date: Fri, 31 Aug 2012 08:42:01 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [RFC,PATCH] efi: Add support for a UEFI variable filesystem
References: <1346319009.951368.767015086462.1.gpush@pecola> <503FA15F.7070506@zytor.com>
In-Reply-To: <503FA15F.7070506@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa,

Thanks for the review!

> However, I have a question... rather than putting the attributes as the
> first data bytes, would it be better to make it either part of the
> filename (assuming there is at least one character other than / which
> can be reasonably relied upon to not be part of the name); for example:
>
> 	LangCodes,BS,RT
>
> ... or ...
>
> 	LangCodes,6

This will get tricky when handling EFI_VARIABLE_APPEND_WRITE: this 
attribute will never appear in the attributes returned by GetVariable(), 
but may be passed to SetVariable(). If we put attributes in the 
filename, we'd need to handle writes to both names, and/or have 
duplicate dentries for each variable. We could do it, but the filesystem 
interface might be a little messy.

[Supporting append writes is essential for key database updates, which 
may be signed]

Cheers,


Jeremy

