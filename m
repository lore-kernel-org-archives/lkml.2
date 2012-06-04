Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2FDOcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:32:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:49575 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab2FDOcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:32:54 -0400
Message-ID: <4FCCC703.2070609@windriver.com>
Date: Mon, 4 Jun 2012 10:32:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: <daniel.santos@pobox.com>
CC: Daniel Santos <danielfsantos@att.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux/bug.h: make BUILD_BUG_ON generate compile-time
 error
References: <4FCC9D7F.7070404@att.net>
In-Reply-To: <4FCC9D7F.7070404@att.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-06-04 07:35 AM, Daniel Santos wrote:
> This is pretty straight-forward. __compiletime_error is defined in
> compiler-gcc4.h with appropriate version checks, so shouldn't break on
> older compilers. This makes the difference between getting an error at
> link-time and getting one at compile time. Example:

It is such a rarity for it to be triggered, that I wonder if it
really matters whether it happens at compile time, or you wait
the extra minute for link time.  Regardless, you've got your
commit log written here, and not in the patch (which was attached
and not inline; preventing comment) and you've not got any
Signed-off line. 

> 
> /home/daniel/proj/kernel/grbtest/grbtest2.c:83:2: error: call to
> ‘__build_bug_on_failed’ declared with attribute error: BUILD_BUG_ON
> failed: !__builtin_constant_p(count)

Also the string "BUILD_BUG_ON failed" is in itself misleading, as if
the macro itself has issues, vs. say using the word "triggered" or 
"tripped" vs. "failed".  You also don't want to put the whole
meaningless paths in commit logs normally (the /home/me/mydir part).

> 
> The above points me directly to where I called BUILD_BUG_ON. Note that
> I'm moving __build_bug_on_failed out of the global scope, just so it can
> be re-declared with different attributes each time.

It wasn't clear to me why you'd want to re-declare things with
different attributes ever.

Paul.

> 
> Daniel
