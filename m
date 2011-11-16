Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab1KPRnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:43:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63358 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab1KPRnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:43:08 -0500
Date: Wed, 16 Nov 2011 09:43:02 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] PM/Memory-hotplug: Avoid task freezing failures
Message-ID: <20111116174302.GD18919@google.com>
References: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com>
 <20111116162601.GB18919@google.com>
 <4EC3F146.7050801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC3F146.7050801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 16, 2011 at 10:52:14PM +0530, Srivatsa S. Bhat wrote:
> So, honestly I didn't understand what is wrong with the approach of this
> patch. And as a consequence, I don't see why we should wait to fix this
> issue. 
> 
> [And by the way recently I happened to see yet another proposed patch
> trying to make use of this API. So wouldn't it be better to fix this
> ASAP, especially when we have a fix readily available?]

It just doesn't look like a proper solution.  Nothing guarantees
freezing will happen soonish.  Not all pm operations involve freezer.
The exclusion is against mem hotplug at this point, right?  I don't
think it's a good idea to add such hack to fix a mostly theoretical
problem and it's actually quite likely someone would be scratching
head trying to figure out why the hell the CPU was hot spinning while
the system is trying to enter one of powersaving mode (we had similar
behavior in freezer code a while back and it was ugly).

So, let's either fix it properly or leave it alone.

Thank you.

-- 
tejun
