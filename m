Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1HXBAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:00:15 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:35507 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754749Ab1HXBAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:00:07 -0400
Subject: Re: RFC: dynamic debug enhancements?
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110823142311.GB2526@redhat.com>
References: <1313972143.11178.55.camel@Joe-Laptop>
	 <20110823142311.GB2526@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 18:00:05 -0700
Message-ID: <1314147605.1659.40.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 10:23 -0400, Jason Baron wrote:
> On Sun, Aug 21, 2011 at 05:15:43PM -0700, Joe Perches wrote:
> > I recently went through drivers/media and updated
> > lots of calls to pr_<level>.
> > A common pattern for debugging there and elsewhere
> > treewide is the use of macros like:
> > #define dprintk(level, fmt, ...)			\
> > do {							\
> > 	if (level > [some_modparam_var])		\
> > 		pr_debug(fmt, ##__VA_ARGS__);		\
> > } while (0)
> > and
> > #define dprintk(mask, fmt, ...)				\
> > do {							\
> > 	if (mask & [some_modparam_var])			\
> > 		pr_debug(fmt, ##__VA_ARGS__);		\
> > } while (0)
> > It might be useful to have standardized calls
> > like pr_debug_level and pr_debug_mask instead
> > of multiple hand-rolled variants treewide.
[]
> looks interesting. I'm wondering how we handle module parameters though?
> In the dynamic debug disabled case, we'd have to standardize the module
> params names. And for the dynamic debug enabled case, I'm not sure how
> we would honor those module params?

One possibility would be to require a #define
before use.

Something like the DEBUG_VARIABLE used in
drivers/media/ and include/media/.

Maybe something like:

#define DYNAMIC_DEBUG_LEVEL_VARIABLE module_var_foo
and/or
#define DYNAMIC_DEBUG_MASK_VARIABLE module_var_bar

and

$ echo 'module <foo> mask <n>' > <debugfs>/dynamic_debug/control
and
$ echo 'module <foo> level <n>' > <debugfs>/dynamic_debug/control

could work to set the module control variable too.


