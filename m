Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1JMOlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab1JMOlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:41:17 -0400
Message-ID: <4E96F887.5050103@redhat.com>
Date: Thu, 13 Oct 2011 16:41:11 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] params: make dashes and underscores in parameter names
 truly equal
References: <1318197817-20964-1-git-send-email-mschmidt@redhat.com> <8739exg588.fsf@rustcorp.com.au>
In-Reply-To: <8739exg588.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 01:28 AM, Rusty Russell wrote:
>          Idea is solid, implementation has a few quirks.  As the name
> obsolete_checksetup() implies, this was only supposed to be a crutch for
> old __setup() calls.  Modern code should be using module_param() or
> core_param().

... instead of __setup()?
No objection to the change in do_early_param() ?

> Did you have a specific example?

The specific example I had in mind was the one from 
Documentation/kernel-parameters.txt:

           log_buf_len=1M print-fatal-signals=1
   can also be entered as
           log-buf-len=1M print_fatal_signals=1

'log-buf-len=1M' does not work because it's an early_param(). 
'print_fatal_signals=1' does not work because it's defined as
__setup("print-fatal-signals=", ...);

> Perhaps we should work on converting
> them all, which would have beneficial side-effects as we poke into old
> code...

Let's see how many __setup() parameters there are:
$ git grep -E '^__setup\("' |wc -l
457

Only the ones with a dash or underscore in the name:
$ git grep -E '__setup\(".*[_-].*"' | wc -l
180

It will take some time.

Thanks,
Michal
