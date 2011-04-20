Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1DTSL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:11:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:3606 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1DTSLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:11:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,247,1301900400"; 
   d="scan'208";a="422777147"
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <gregkh@suse.de>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <20110420014340.GA21245@suse.de>
References: <james_p_freyensee@linux.intel.com>
	 <1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com>
	 <1303258222.13457.42.camel@localhost>
	 <alpine.DEB.2.00.1104191817590.8047@chino.kir.corp.google.com>
	 <20110420014340.GA21245@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 20 Apr 2011 11:11:23 -0700
Message-ID: <1303323083.13457.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 18:43 -0700, Greg KH wrote:
> On Tue, Apr 19, 2011 at 06:22:14PM -0700, David Rientjes wrote:
> > On Tue, 19 Apr 2011, J Freyensee wrote:
> > 
> > > > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > > 
> > > > > This allows drivers who call this function to be compiled modularly.
> > > > > Otherwise, a driver who is interested in this type of functionality
> > > > > has to implement their own get_task_comm() call, causing code
> > > > > duplication in the Linux source tree.
> > > > > 
> > > > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > 
> > > > Acked-by: David Rientjes <rientjes@google.com>
> > > > 
> > > > There've been some other patchsets proposed recently that need to print a 
> > > > thread's comm and since /proc/pid/comm can change the comm's of other 
> > > > threads out from under them, it's necessary to serialize access to it with 
> > > > task_lock().  This patch certainly makes it easier for modules to do so 
> > > > correctly, thanks!
> > > 
> > > Thanks for the compliment; it's appreciated.  I've made my patch sets
> > > independent from one another.  And I believe a common consensus (at
> > > least with Greg KH, Alan C., Arjan VdV and myself) was achieved that
> > > this is a good patch to apply? So maybe this can be applied to the
> > > kernel, independent of my other patches, so this will fit your needs?
> > > 
> > 
> > This patch in particular can probably go through the -mm tree; the last 
> > activity for get_task_comm() was three years ago (59714d65dfbc 
> > "get_task_comm(): return the result") which also went through the -mm tree 
> > and its export is a general service to module authors.  Let's cc Andrew 
> > and see if he'll merge it.
> 
> No, let's wait for the other patches to get acceptable before we merge
> it.  We don't need to add exports when there are no users of it in the
> tree. It's not for .39 at this point anyway, so no rush at the moment.
> 

But as David pointed out, if there is work other than mine coming that
has already been proposed, wouldn't it be good to get this patch in
place now to start the encouragement of future eyes to just call this
function than re-invent the wheel?

> thanks,
> 
> greg k-h


