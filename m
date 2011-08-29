Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1H2SWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:22:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49042 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1H2SWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <1314147605.1659.40.camel@Joe-Laptop>
References: <1313972143.11178.55.camel@Joe-Laptop> <20110823142311.GB2526@redhat.com>
 <1314147605.1659.40.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 29 Aug 2011 12:21:53 -0600
Message-ID: <CAJfuBxwFvRvy=umR-C1S8+pawQ8HtD_m-X5zAQ0cTBpCkpWcHA@mail.gmail.com>
Subject: Re: RFC: dynamic debug enhancements?
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 7:00 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-08-23 at 10:23 -0400, Jason Baron wrote:
>> On Sun, Aug 21, 2011 at 05:15:43PM -0700, Joe Perches wrote:
>> > I recently went through drivers/media and updated
>> > lots of calls to pr_<level>.
>> > A common pattern for debugging there and elsewhere
>> > treewide is the use of macros like:
>> > #define dprintk(level, fmt, ...)                    \
>> > do {                                                        \
>> >     if (level > [some_modparam_var])                \
>> >             pr_debug(fmt, ##__VA_ARGS__);           \
>> > } while (0)
>> > and
>> > #define dprintk(mask, fmt, ...)                             \
>> > do {                                                        \
>> >     if (mask & [some_modparam_var])                 \
>> >             pr_debug(fmt, ##__VA_ARGS__);           \
>> > } while (0)
>> > It might be useful to have standardized calls
>> > like pr_debug_level and pr_debug_mask instead
>> > of multiple hand-rolled variants treewide.
> []
>> looks interesting. I'm wondering how we handle module parameters though?
>> In the dynamic debug disabled case, we'd have to standardize the module
>> params names. And for the dynamic debug enabled case, I'm not sure how
>> we would honor those module params?
>
> One possibility would be to require a #define
> before use.
>
> Something like the DEBUG_VARIABLE used in
> drivers/media/ and include/media/.
>
> Maybe something like:
>
> #define DYNAMIC_DEBUG_LEVEL_VARIABLE module_var_foo
> and/or
> #define DYNAMIC_DEBUG_MASK_VARIABLE module_var_bar
>
> and
>
> $ echo 'module <foo> mask <n>' > <debugfs>/dynamic_debug/control
> and
> $ echo 'module <foo> level <n>' > <debugfs>/dynamic_debug/control
>
> could work to set the module control variable too.
>
>
>

how about just passing in condition directly ?

#define pr_dbg_if( cond, fmt, ... )                  \
do {                                                        \
    if (cond)                \
            pr_debug(fmt, ##__VA_ARGS__);           \
} while (0)

this will serve both mask and level, and could underlie both of them,
and its clear - no hidden checks against a variable named elsewhere.
