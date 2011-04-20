Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1DTT46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:56:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:46389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab1DTT45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:56:57 -0400
Date: Wed, 20 Apr 2011 12:14:21 -0700
From: Greg KH <gregkh@suse.de>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
Message-ID: <20110420191421.GA10306@suse.de>
References: <james_p_freyensee@linux.intel.com>
 <1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com>
 <alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com>
 <1303258222.13457.42.camel@localhost>
 <alpine.DEB.2.00.1104191817590.8047@chino.kir.corp.google.com>
 <20110420014340.GA21245@suse.de>
 <1303323083.13457.50.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303323083.13457.50.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 11:11:23AM -0700, J Freyensee wrote:
> On Tue, 2011-04-19 at 18:43 -0700, Greg KH wrote:
> > On Tue, Apr 19, 2011 at 06:22:14PM -0700, David Rientjes wrote:
> > > On Tue, 19 Apr 2011, J Freyensee wrote:
> > > 
> > > > > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > > > 
> > > > > > This allows drivers who call this function to be compiled modularly.
> > > > > > Otherwise, a driver who is interested in this type of functionality
> > > > > > has to implement their own get_task_comm() call, causing code
> > > > > > duplication in the Linux source tree.
> > > > > > 
> > > > > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > > 
> > > > > Acked-by: David Rientjes <rientjes@google.com>
> > > > > 
> > > > > There've been some other patchsets proposed recently that need to print a 
> > > > > thread's comm and since /proc/pid/comm can change the comm's of other 
> > > > > threads out from under them, it's necessary to serialize access to it with 
> > > > > task_lock().  This patch certainly makes it easier for modules to do so 
> > > > > correctly, thanks!
> > > > 
> > > > Thanks for the compliment; it's appreciated.  I've made my patch sets
> > > > independent from one another.  And I believe a common consensus (at
> > > > least with Greg KH, Alan C., Arjan VdV and myself) was achieved that
> > > > this is a good patch to apply? So maybe this can be applied to the
> > > > kernel, independent of my other patches, so this will fit your needs?
> > > > 
> > > 
> > > This patch in particular can probably go through the -mm tree; the last 
> > > activity for get_task_comm() was three years ago (59714d65dfbc 
> > > "get_task_comm(): return the result") which also went through the -mm tree 
> > > and its export is a general service to module authors.  Let's cc Andrew 
> > > and see if he'll merge it.
> > 
> > No, let's wait for the other patches to get acceptable before we merge
> > it.  We don't need to add exports when there are no users of it in the
> > tree. It's not for .39 at this point anyway, so no rush at the moment.
> > 
> 
> But as David pointed out, if there is work other than mine coming that
> has already been proposed, wouldn't it be good to get this patch in
> place now to start the encouragement of future eyes to just call this
> function than re-invent the wheel?

No, then those projects submit the patch to export this, if they happen
to get to mainline before this one does.

Again, don't export something unless you are using it at the time, no
"this is to be used hopefully by something in the future" type stuff
please.  Who knows if those future plans ever pan out.

thanks,

greg k-h
