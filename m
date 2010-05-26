Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119Ab0EZSgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:36:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab0EZSgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:36:10 -0400
Date: Wed, 26 May 2010 14:35:59 -0400
From: Jason Baron <jbaron@redhat.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: allow to set dynamic debug flags right
	at module load time
Message-ID: <20100526183559.GA5094@redhat.com>
References: <201005261425.39058.roman.fietze@telemotive.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005261425.39058.roman.fietze@telemotive.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 02:25:38PM +0200, Roman Fietze wrote:
> Hello Jason, hello list,
> 
> If I'm not wrong one could only enable any dynamic debugging flag
> after a module had been completely loaded, using debugfs. This makes
> it impossible to use dev_dbg or pr_debug e.g. inside the module init
> function or any function called by it.
> 

yes, that's correct.

> My patch works by replacing _DPRINTK_FLAGS_DEFAULT after including all
> kernel headers in my module source file and some small patch inside
> dynamic_debug.c setting up the internal variables already when loading
> a module with flags unequal to zero. This patch can of course be
> optimized somewhat by reusing existing variables.
> 
> Subject: [PATCH] dynamic_debug: allow to set dynamic debug flags right at module load time
> 
> This allows to use e.g. pr_debug right from the beginning, e.g. in the
> module init function.
> 
> - the module must redefine _DPRINTK_FLAGS_DEFAULT, e.g.
> 
>   #undef _DPRINTK_FLAGS_DEFAULT
>   #define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
> 
> - when a module is loaded and the flags are not zero, the enabled
>   count and hash masks are enabled right away
> 

it's a good idea, but i think we want this to be runtime configurable.
That is, we probably want this implemented as a module parameter, not as
a compile time thing. something like: modprobe module verbose=1

thanks,

-Jason
