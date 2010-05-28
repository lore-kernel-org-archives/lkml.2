Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0E1N4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab0E1N4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:56:21 -0400
Date: Fri, 28 May 2010 09:55:49 -0400
From: Jason Baron <jbaron@redhat.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: allow to set dynamic debug flags right at
 module load time
Message-ID: <20100528135549.GA2528@redhat.com>
References: <201005261425.39058.roman.fietze@telemotive.de>
 <20100526183559.GA5094@redhat.com>
 <201005270705.44179.roman.fietze@telemotive.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005270705.44179.roman.fietze@telemotive.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:05:43AM +0200, Roman Fietze wrote:
> Hello Jason,
> 
> On Wednesday 26 May 2010 20:35:59 Jason Baron wrote:
> 
> > ... we want this to be runtime configurable.
> > That is, we probably want this implemented as a module parameter, not as
> > a compile time thing. something like: modprobe module verbose=1
> 
> Kind of
> 
> #define dynamic_pr_debug(fmt, ...) do {					\
> 	...
> 		DEBUG_HASH2, __LINE__,					\
> 		verbose ? _DPRINTK_FLAGS_PRINT : _DPRINTK_FLAGS_DEFAULT}; \
> 	...
> 
> But what if verbose isn't there?
> 
> Or something smarter inside dynamic_debug_setup() or
> ddebug_add_module() looking for a module symbol or parameter with that
> name?
> 

right, i think we want to add something inside ddebug_add_module() that
recognizes if the module was loaded with verbose=1. I think you can get
at the parameters via module->kp, which we need to pass in as well.

There is also a naming issue, in that if we "reserve" the param
"verbose", how do we make sure no other module wants to use that as a
module parameter name. Or maybe it doesn't matter if we don't consume
the parameter. That is, the parameter can mean 2 things. not sure.

thanks,

-Jason
