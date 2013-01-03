Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3ACWP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:15:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46578 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3ACWPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:15:24 -0500
Message-ID: <50E602D4.8020604@oracle.com>
Date: Thu, 03 Jan 2013 17:14:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: prevent warning when finit_module a 0 sized file
References: <1356722837-1457-1-git-send-email-sasha.levin@oracle.com> <877gnv5c9s.fsf@rustcorp.com.au>
In-Reply-To: <877gnv5c9s.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 07:41 PM, Rusty Russell wrote:
> Sasha Levin <sasha.levin@oracle.com> writes:
> 
>> If we try to finit_module on a file sized 0 bytes vmalloc will
>> scream and spit out a warning.
>>
>> Since modules have to be bigger than 0 bytes anyways we can just
>> check that beforehand and avoid the warning.
> 
> Applied, but I added the comment you somehow missed :)

Thanks!

I do have a somewhat related follow-up question:

When init_module() goes through the module loading process, it will try to vmalloc()
whatever size passed to it by the user, which may cause vmalloc() to scream and shout
if the size passed from userspace is too big.

Do you think that reading just the header and doing a quick elf_header_check() on
it before trying to read the entire file would make sense here?


Thanks,
Sasha
