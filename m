Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1HKFpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:45:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42516 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1HKFpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <1313024628.11924.139.camel@Joe-Laptop>
References: <CAJfuBxwq3xw3MZU01rwzg0NAnnxNoLrC2x0QXnj+2pD-6gkR4g@mail.gmail.com>
 <1313020216.11924.129.camel@Joe-Laptop> <1313020897.11924.137.camel@Joe-Laptop>
 <20110811002039.GA3552@redhat.com> <1313024628.11924.139.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 10 Aug 2011 23:44:46 -0600
Message-ID: <CAJfuBxyNBxs0hcTV=0N1UBYWnuXKsMUq3DC3GDgedRL5YX+34A@mail.gmail.com>
Subject: Re: RFC: Use dynamic-debug with pr_debug when -DDEBUG is set
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 7:03 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2011-08-10 at 20:20 -0400, Jason Baron wrote:
>> On Wed, Aug 10, 2011 at 05:01:37PM -0700, Joe Perches wrote:
>> > Perhaps another way to enable pr_debug use
>> > is to reverse the order of dynamic_pr_debug
>> > defines.
>> > ie:  change printk.h:
>> > #if defined(CONFIG_DYNAMIC_DEBUG)
>> > /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
>> > #define pr_debug(fmt, ...) \
>> >     dynamic_pr_debug(fmt, ##__VA_ARGS__)
>> > #elif defined(DEBUG)
>> > #define pr_debug(fmt, ...) \
>> >     printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>> > and change dynamic_debug.h:
>> > #define DPRINTK_FLAGS_DEFAULT 0
>> > to:
>> > #if defined DEBUG
>> > #define DPRINTK_FLAGS_DEFAULT DPRINTK_FLAGS_PRINT
>> > #else
>> > #define DPRINT_FLAGS_DEFAULT 0
>> > #endif
>> > That seems pretty sensible to me.  Jason?
>> cool idea. I like it.
>
> You've got a bunch of patches ready to
> be pulled/queued, so I think you should
> do it.
>
> cheers, Joe
>

Thanks Joe,

Ive just added this.  It works nicely, with one trivial change
to add MODNAME, imitating the common non-dynamic-debug usage:

#if defined DEBUG
#define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT |
_DPRINTK_FLAGS_INCL_MODNAME

Ive tested the changes on scx200_acb, and changed
the printks therein to corresponding pr_<foo>
As I said, it works nicely.

Ive added these 2 patches to my series, which I'll be posting shortly.
In the meantime, its available at:

git://github.com/jimc/linux-2.6.git
in branch dyndbg-v4
