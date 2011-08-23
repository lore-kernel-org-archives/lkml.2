Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1HWOXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:23:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1HWOXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:23:14 -0400
Date: Tue, 23 Aug 2011 10:23:11 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: dynamic debug enhancements?
Message-ID: <20110823142311.GB2526@redhat.com>
References: <1313972143.11178.55.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313972143.11178.55.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 05:15:43PM -0700, Joe Perches wrote:
> 
> I recently went through drivers/media and updated
> lots of calls to pr_<level>.
> 
> A common pattern for debugging there and elsewhere
> treewide is the use of macros like:
> 
> #define dprintk(level, fmt, ...)			\
> do {							\
> 	if (level > [some_modparam_var])		\
> 		pr_debug(fmt, ##__VA_ARGS__);		\
> } while (0)
> 
> and
> 
> #define dprintk(mask, fmt, ...)				\
> do {							\
> 	if (mask & [some_modparam_var])			\
> 		pr_debug(fmt, ##__VA_ARGS__);		\
> } while (0)
> 
> It might be useful to have standardized calls
> like pr_debug_level and pr_debug_mask instead
> of multiple hand-rolled variants treewide.
> 
> Another common thing was the use of various
> __FILE__, __func__, __LINE__ outputs.
> 
> I think __FILE__ is not particularly useful and
> can reasonably be replaced by KBUILD_MODNAME.
> 
> Perhaps it would be good to have options to
> enable these outputs with specific controls
> for dynamic_debug uses.
> 
> Maybe something like using a define similar to
> pr_fmt for what options are preselected for
> various ddebug outputs like:
> 
> #define DYNAMIC_DEBUG_DEFAULT_FLAGS 		\
> 	(_DPRINTK_FLAGS_INCL_MODNAME |		\
> 	 _DPRINTK_FLAGS_INCL_FUNCNAME |		\
> 	 _DPRINTK_FLAGS_INCL_LINENO)
> 
> 

Hi Joe,

looks interesting. I'm wondering how we handle module parameters though?
In the dynamic debug disabled case, we'd have to standardize the module
params names. And for the dynamic debug enabled case, I'm not sure how
we would honor those module params?

-Jason
