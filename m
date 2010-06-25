Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab0FYEdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 00:33:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65516 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0FYEdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 00:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TLqycB8v/r5vREfSYmrwBkJyd+50msZ1biZGSWqm1v+9mKG0B8bVsCJR0LQCutgAmC
         2384gLAJIU2rVWgW/rYADUqZq2JnyPAKS3ckHuU77/GLHl4KH0U+0Z8hajyYGuxKdZJg
         gfxR+X1KzSN3Q2mRz59XZM4Fzt4s5VAsrmXkc=
Message-ID: <4C24319F.1030307@garzik.org>
Date: Fri, 25 Jun 2010 00:33:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Andreas Dilger <adilger@dilger.ca>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
References: <20100624131455.GA10441@laptop> <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca> <20100625040156.GQ10441@laptop>
In-Reply-To: <20100625040156.GQ10441@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 12:01 AM, Nick Piggin wrote:
> So is "frsize" supposed to be the optimal block size, or what?
> f_bsize AFAIKS should be filesystem allocation block size because
> apparently some programs require it to calculate size of file on
> disk.
>
> If we can't change existing suboptimal legacy things, then let's
> introduce new APIs that do the right thing. Apps that care will
> eventually start using eg. a new syscall.
>
>>
>>> - statvfs(2) lacks f_type.
>>>
>>> Is there anything more we should add here? Samba wants a capabilities
>>> field, with things like sparse files, quotas, compression, encryption,
>>> case preserving/sensitive.
>>
>> It wouldn't be a bad idea, but then you could get into issues of what exactly the above flags mean.  That said, I think it is better to have broad categories of features that may be slightly ill-defined than having nothing at all.
>
> Yes it would be tricky. I don't want to add features that will just
> be useless or go unused, but I don't want to change the syscall API
> just to add f_flags, without looking at other possibilities.


It would be nice to separate capabilities and fixed parameters (block 
size) from statistics which change frequently (free space).

And are capabilities really suited to a C struct, at all?  That seems 
more suited to a key/value type interface, a la NFSv4 attributes.

	Jeff



