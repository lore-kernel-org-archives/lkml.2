Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1DVXAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:00:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:20531 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1DVXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:00:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="424151878"
Subject: Re: [PATCH] export kernel call get_task_comm().
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <gregkh@suse.de>
Cc: akpm@linux-foundation.org, rientjes@google.com,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <20110422224308.GA301@suse.de>
References: <james_p_freyensee@linux.intel.com>
	 <1303511744-815-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110422224308.GA301@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 22 Apr 2011 15:59:42 -0700
Message-ID: <1303513182.13457.134.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 15:43 -0700, Greg KH wrote:
> On Fri, Apr 22, 2011 at 03:35:44PM -0700, james_p_freyensee@linux.intel.com wrote:
> > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > This allows drivers who call this function to be compiled modularly.
> > Otherwise, a driver who is interested in this type of functionality
> > has to implement their own get_task_comm() call, causing code
> > duplication in the Linux source tree.
> > 
> > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> I think the goal is for the cleanup to happen now, to justify the
> addition of the exported symbol.  Without that, there is no need to
> export the symbol now at all, as who knows when your driver will be
> accepted.
> 
> Or, just wait and make it part of your driver patch series, like you did
> before, no need to get it accepted now, right?
>

Well, at some point a few people like Alan Cox and Arjan VdV would like
to see this work on it's way to Linus's tree.

I'll do whatever is best and easiest for you and will bring a close to
my submission attempts.  I can also just go into the Kconfig where the
pti driver is configured and just make the selection bool, yes or no,
and not make it an option to compile this modularly.  Then I'll drop
this patch all together.  This is the whole reason why I'm making this
change.  I don't have to have the pti driver as a module, just more
convenient.  And within the fs/exec.c it states reads to 'current->comm'
without a lock is safe.

> thanks,
> 
> greg k-h


