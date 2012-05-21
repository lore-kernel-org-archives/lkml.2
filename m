Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2EUEqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 00:46:23 -0400
Received: from linux-sh.org ([111.68.239.195]:51361 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2EUEqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 00:46:22 -0400
Date: Mon, 21 May 2012 13:46:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] irqdomain: Simple NUMA awareness.
Message-ID: <20120521044618.GC31763@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
 <1337407908-7421-5-git-send-email-lethal@linux-sh.org>
 <20120519184135.8CFBD3E03B8@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120519184135.8CFBD3E03B8@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 12:41:35PM -0600, Grant Likely wrote:
> On Sat, 19 May 2012 15:11:44 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> > +static inline int irq_domain_nid(struct device_node *of_node)
> > +{
> > +	return of_node ? of_node_to_nid(of_node) : numa_node_id();
> > +}
> > +
> 
> I think this logic should just be rolled into of_node_to_nid()
> directly instead of an irq_domain-specific helper.  PowerPC and Sparc
> are the only architectures doing anything special with of_node_to_nid
> at the moment.  I don't think anyone has bothered to define an
> arch-independent binding for NUMA associations.
> 
> Otherwise this patch looks good to me.
> 
Ok, that sounds fine to me. I've done that in the updated patch. We do
need to include linux/topology.h for the numa_node_id() definition, but
that seems to not cause too much trouble. Cross builds for sparc and
powerpc OF + NUMA platforms seem to hold up at least.
