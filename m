Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1DMLol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:44:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63246 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab1DMLok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l+PAviOZNcuIlL/CjeCo+AXIQFEmZdzwDLjULKG5/BWEJa9AzARMO6d1wA12PquV6T
         tXcTJ+omahEjHQuaOqXmdlUEtmTYpG8fyk9aCy53cnpeuOlWug46gTL9M26MCiaeOXHY
         pbSY0l5lZQbD5weJZVaEzlrrIExV2V9hzyls0=
MIME-Version: 1.0
In-Reply-To: <530486.50523.qm@web162020.mail.bf1.yahoo.com>
References: <1302662256.2811.27.camel@edumazet-laptop>
	<530486.50523.qm@web162020.mail.bf1.yahoo.com>
Date: Wed, 13 Apr 2011 19:44:39 +0800
Message-ID: <BANLkTi=7KHMA_JOwQcMQj5M+XU=qO07s2g@mail.gmail.com>
Subject: Re: Regarding memory fragmentation using malloc....
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 2:54 PM, Pintu Agarwal <pintu_agarwal@yahoo.com> wrote:
> Dear All,
>
> I am trying to understand how memory fragmentation occurs in linux using many malloc calls.
> I am trying to reproduce the page fragmentation problem in linux 2.6.29.x on a linux mobile(without Swap) using a small malloc(in loop) test program of BLOCK_SIZE (64*(4*K)).
> And then monitoring the page changes in /proc/buddyinfo after each operation.
> From the output I can see that the page values under buddyinfo keeps changing. But I am not able to relate these changes with my malloc BLOCK_SIZE.
> I mean with my BLOCK_SIZE of (2^6 x 4K ==> 2^6 PAGES) the 2^6 th block under /proc/buddyinfo should change. But this is not the actual behaviour.
> Whatever is the blocksize, the buddyinfo changes only for 2^0 or 2^1 or 2^2 or 2^3.
>
> I am trying to measure the level of fragmentation after each page allocation.
> Can somebody explain me in detail, how actually /proc/buddyinfo changes after each allocation and deallocation.
>

What malloc() sees is virtual memory of the process, while buddyinfo
shows physical memory pages.

When you malloc() 64K memory, the kernel may not allocate a 64K
physical memory at one time
for you.

Thanks.
