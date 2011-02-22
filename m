Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1BVWzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:55:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:47558 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1BVWzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:55:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,208,1297065600"; 
   d="scan'208";a="890232366"
Subject: Re: [PATCH 09/12] n_tracesink header file.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
In-Reply-To: <20110222202625.GA24164@suse.de>
References: <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110217192300.GD29448@kroah.com> <1297971915.3038.32.camel@localhost>
	 <20110217195400.GB12172@kroah.com> <1297973447.3038.36.camel@localhost>
	 <20110217214348.GA2193@kroah.com> <1298406178.2315.7.camel@localhost>
	 <20110222202625.GA24164@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Feb 2011 14:55:21 -0800
Message-ID: <1298415321.2315.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 12:26 -0800, Greg KH wrote:
> On Tue, Feb 22, 2011 at 12:22:58PM -0800, J Freyensee wrote:
> > On Thu, 2011-02-17 at 13:43 -0800, Greg KH wrote:
> > > On Thu, Feb 17, 2011 at 12:10:47PM -0800, J Freyensee wrote:
> > > > On Thu, 2011-02-17 at 11:54 -0800, Greg KH wrote:
> > > > > On Thu, Feb 17, 2011 at 11:45:15AM -0800, J Freyensee wrote:
> > > > > > On Thu, 2011-02-17 at 11:23 -0800, Greg KH wrote:
> > > > > > > On Tue, Feb 08, 2011 at 11:34:54AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > > > > > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > > > > > 
> > > > > > > > This header file allows the n_tracerouter to send it's information
> > > > > > > > to the n_tracesink ldisc driver.  It's part of the Intel-Atom
> > > > > > > > PTI implementation solution.
> > > > > > > > 
> > > > > > > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > > > > > ---
> > > > > > > >  include/linux/n_tracesink.h |   32 ++++++++++++++++++++++++++++++++
> > > > > > > 
> > > > > > > Why is this in include/linux/ ?
> > > > > > > 
> > > > > > 
> > > > > > I thought this was the best place to stick this .h file.  I'd be happy
> > > > > > to change locations based off of your suggestion.
> > > > > 
> > > > > Why do you need a .h file at all?  Who is using it?
> > > > 
> > > > The only current module that really uses it is n_tracerouter; however, I
> > > > thought sticking this in a .h file made things slightly more modular and
> > > > more re-usable, especially for future device driver writers that could
> > > > want something like this.
> > > > 
> > > > If you would like me to remove this though, I can, just let me know.
> > > 
> > > Yes, please remove it.
> > > 
> > Greg,
> > 
> > If I remove this file I need to add the function header
> > n_tracesink_datadrain() that is in this file to n_tracerouter.c.
> > 
> > If I add that function header to n_tracerouter.c then checkpatch.pl
> > complains that extern should be avoided in .c files.
> > 
> > If I don't have this function header in n_tracerouter.c then it won't
> > compile at all.
> > 
> > Do you have an alternative suggestion on what I should do here?  It
> > appears the best solution is for me to keep this .h file considering the
> > constraints.
> 
> Make it a "local" .h file, in the same directory as these two .c files,
> no need to make it global for the whole of the kernel tree, right?
> 

yes, you are right, I don't think it needs to be global for the whole
tree since the two .c files are in the same place and they are the only
ones that care about it.

Jay

> thanks,
> 
> greg k-h


