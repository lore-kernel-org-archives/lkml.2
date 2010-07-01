Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0GAUn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:43:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab0GAUn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:43:28 -0400
Date: Thu, 1 Jul 2010 16:43:19 -0400
From: Jason Baron <jbaron@redhat.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: allow to set dynamic debug flags right
	at module load time
Message-ID: <20100701204318.GG2829@redhat.com>
References: <201005261425.39058.roman.fietze@telemotive.de> <201005270705.44179.roman.fietze@telemotive.de> <20100528135549.GA2528@redhat.com> <201006291325.29983.roman.fietze@telemotive.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006291325.29983.roman.fietze@telemotive.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 01:25:29PM +0200, Roman Fietze wrote:
> Hello Jason, hello LKML,
> 
> On Friday 28 May 2010 15:55:49 Jason Baron wrote:
> 
> > right, i think we want to add something inside ddebug_add_module()
> > that recognizes if the module was loaded with verbose=1. I think you
> > can get at the parameters via module->kp, which we need to pass in
> > as well.
> 
> Yes, I would first check if there's a section named "__verbose" as it
> is right now. If yes, I would search the already setup module->kp for
> the used parameter.
>
> 
> Proposals, not being sure how to implement that right now:
> 
> Default is to search e.g. for param "dprintk".
> 

make sense.

> Provide a macro to override that default, e.g.
> DPRINTK_PARAM("verbose")
>

why would we want to override it?
 
> If the default or defined bool or other integer parameter is unequal
> to 0 enable the p-flag on module load for all debug statements of this
> module.
> 
> 
> Questions just in case the proposal is kind of ok:
> 
> Prepare the code to allow the setting of different future flags
> unequal to 'p'?
> 
> Use a charp param instead of a bool to allow that?
> 

yes, we might eventually want more than a bool, but unless you have a
specific case in mind, I would keep as simple as possible for now.

thanks,

-Jason
