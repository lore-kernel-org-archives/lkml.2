Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3AGBRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:17:33 -0500
Received: from ozlabs.org ([203.10.76.45]:44546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3AGBRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:17:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: prevent warning when finit_module a 0 sized file
In-Reply-To: <50E602D4.8020604@oracle.com>
References: <1356722837-1457-1-git-send-email-sasha.levin@oracle.com> <877gnv5c9s.fsf@rustcorp.com.au> <50E602D4.8020604@oracle.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 07 Jan 2013 11:20:16 +1030
Message-ID: <87k3rp4y0n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:
> On 01/02/2013 07:41 PM, Rusty Russell wrote:
>> Sasha Levin <sasha.levin@oracle.com> writes:
>> 
>>> If we try to finit_module on a file sized 0 bytes vmalloc will
>>> scream and spit out a warning.
>>>
>>> Since modules have to be bigger than 0 bytes anyways we can just
>>> check that beforehand and avoid the warning.
>> 
>> Applied, but I added the comment you somehow missed :)
>
> Thanks!
>
> I do have a somewhat related follow-up question:
>
> When init_module() goes through the module loading process, it will try to vmalloc()
> whatever size passed to it by the user, which may cause vmalloc() to scream and shout
> if the size passed from userspace is too big.
>
> Do you think that reading just the header and doing a quick elf_header_check() on
> it before trying to read the entire file would make sense here?

No.  Root asked, we do.  If modprobe wants to check the header, let it.

Cheers,
Rusty.
