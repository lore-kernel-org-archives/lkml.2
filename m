Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1HVAPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:15:46 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:47275 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752257Ab1HVAPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:15:45 -0400
Subject: RFC: dynamic debug enhancements?
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Aug 2011 17:15:43 -0700
Message-ID: <1313972143.11178.55.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jason.

I recently went through drivers/media and updated
lots of calls to pr_<level>.

A common pattern for debugging there and elsewhere
treewide is the use of macros like:

#define dprintk(level, fmt, ...)			\
do {							\
	if (level > [some_modparam_var])		\
		pr_debug(fmt, ##__VA_ARGS__);		\
} while (0)

and

#define dprintk(mask, fmt, ...)				\
do {							\
	if (mask & [some_modparam_var])			\
		pr_debug(fmt, ##__VA_ARGS__);		\
} while (0)

It might be useful to have standardized calls
like pr_debug_level and pr_debug_mask instead
of multiple hand-rolled variants treewide.

Another common thing was the use of various
__FILE__, __func__, __LINE__ outputs.

I think __FILE__ is not particularly useful and
can reasonably be replaced by KBUILD_MODNAME.

Perhaps it would be good to have options to
enable these outputs with specific controls
for dynamic_debug uses.

Maybe something like using a define similar to
pr_fmt for what options are preselected for
various ddebug outputs like:

#define DYNAMIC_DEBUG_DEFAULT_FLAGS 		\
	(_DPRINTK_FLAGS_INCL_MODNAME |		\
	 _DPRINTK_FLAGS_INCL_FUNCNAME |		\
	 _DPRINTK_FLAGS_INCL_LINENO)


