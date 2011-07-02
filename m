Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1GBRE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:04:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61365 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1GBRE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:04:26 -0400
MIME-Version: 1.0
In-Reply-To: <1309625250.24186.1224.camel@localhost>
References: <1309622006-28343-1-git-send-email-jonas@southpole.se>
 <CAMjpGUfZwZu-ZCJj2cmq1w6B71-gQ8G27FpYdhseyq3hoZRL+Q@mail.gmail.com> <1309625250.24186.1224.camel@localhost>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 2 Jul 2011 13:04:05 -0400
X-Google-Sender-Auth: 9fr8QIQY5iugPijy2k06z_E3GZE
Message-ID: <CAMjpGUeMqVzcAWKpAojZVbj9ywH+4HmW4Hx-8D1WQmTqPSNqQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] asm-generic: add MMU variants of io.h functions
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        liqin.chen@sunplusct.com, gxt@mprc.pku.edu.cn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 12:47, Jonas Bonn wrote:
> On Sat, 2011-07-02 at 12:38 -0400, Mike Frysinger wrote:
>> On Sat, Jul 2, 2011 at 11:53, Jonas Bonn wrote:
>> > +#ifdef CONFIG_MMU
>> > +#define xlate_dev_mem_ptr(p)   __va(p)
>> > +#else
>> >  #define xlate_dev_mem_ptr(p)   ((void *) (p))
>> > +#endif
>>
>> i wonder if we could do:
>> #ifndef __va
>> #define __va(p) ((void *)(p))
>> #endif
>> #define xlate_dev_mem_ptr(p)   __va(p)
>> -mike
>
> This seems to introduce an artificial definition of a "virtual" address
> for systems without an MMU, which strikes me as a bit odd.  If this is
> what people prefer, that's fine... I think I prefer the former variant,
> though.

this isnt a problem.  we do this sort of thing in many places since
people develop under MMU and use the API that exists there.

however, i see that we already have __va() in asm-generic/page.h.  so
you can assume __va() exists.  so just change the existing definition
to:
#define xlate_dev_mem_ptr(p)   __va(p)
-mike
