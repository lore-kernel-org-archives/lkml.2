Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1HKBDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 21:03:53 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:46626 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754662Ab1HKBDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 21:03:52 -0400
Subject: Re: RFC: Use dynamic-debug with pr_debug when -DDEBUG is set
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
In-Reply-To: <20110811002039.GA3552@redhat.com>
References: <CAJfuBxwq3xw3MZU01rwzg0NAnnxNoLrC2x0QXnj+2pD-6gkR4g@mail.gmail.com>
	 <1313020216.11924.129.camel@Joe-Laptop>
	 <1313020897.11924.137.camel@Joe-Laptop>  <20110811002039.GA3552@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 18:03:48 -0700
Message-ID: <1313024628.11924.139.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 20:20 -0400, Jason Baron wrote:
> On Wed, Aug 10, 2011 at 05:01:37PM -0700, Joe Perches wrote:
> > Perhaps another way to enable pr_debug use
> > is to reverse the order of dynamic_pr_debug
> > defines.
> > ie:  change printk.h:
> > #if defined(CONFIG_DYNAMIC_DEBUG)
> > /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
> > #define pr_debug(fmt, ...) \
> > 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
> > #elif defined(DEBUG)
> > #define pr_debug(fmt, ...) \
> > 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> > and change dynamic_debug.h:
> > #define DPRINTK_FLAGS_DEFAULT 0
> > to:
> > #if defined DEBUG
> > #define DPRINTK_FLAGS_DEFAULT DPRINTK_FLAGS_PRINT
> > #else
> > #define DPRINT_FLAGS_DEFAULT 0
> > #endif
> > That seems pretty sensible to me.  Jason?
> cool idea. I like it.

You've got a bunch of patches ready to
be pulled/queued, so I think you should
do it.

cheers, Joe


