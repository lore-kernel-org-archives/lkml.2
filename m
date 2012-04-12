Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab2DLRrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:47:07 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47398 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2DLRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:47:05 -0400
Message-ID: <4F8714F5.1050605@windriver.com>
Date: Thu, 12 Apr 2012 13:46:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <tony@bakeyournoodle.com>, <mmarek@suse.cz>, <lacombar@gmail.com>
Subject: Re: [PATCH 5/5] kconfig: limit IS_ENABLED & similar to CPP usage
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com> <1334188257-3449-6-git-send-email-paul.gortmaker@windriver.com> <CA+55aFxmpotS+Yw0niuYRq4eqpYjx6=TAvoz8v=NxD3N_7u7qg@mail.gmail.com>
In-Reply-To: <CA+55aFxmpotS+Yw0niuYRq4eqpYjx6=TAvoz8v=NxD3N_7u7qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-11 08:04 PM, Linus Torvalds wrote:
> On Wed, Apr 11, 2012 at 4:50 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> Using IS_ENABLED() within C (vs. within CPP #if statements) requires
>> us to actually define every possible bool/tristate Kconfig option
>> twice (__enabled_* and __enabled_*_MODULE variants).
> 
> Why do you keep the __enabled_*[_MODULE] things alive at all?

Good point.  Clearly I wasn't aggressive enough in my shitectomy.
Testing with no __enabled_* stuff now.  That reduces the line
count even more, which is nice.

I've not auto-prefixed the CONFIG_ though, since that seems to break
the grep use case.

P.

> 
> Why can't you just check the CONFIG_xyz[_MODULE] #defines directly?
> 
> IOW, why isn't IS_ENABLED() just
> 
>   #define IS_ENABLED(option) \
>     (defined(CONFIG_##option) || defined(CONFIG_##option##_MODULE))
> 
>   #define IS_BUILTIN(option) \
>     (defined(CONFIG_##option))
> 
> and we're done with it all? What's the advantage of the __enabled_
> thing again, when you depend on the preprocessor anyway?
> 
>                       Linus
