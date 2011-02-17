Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1BQUNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:13:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:49437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab1BQUNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:13:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,182,1297065600"; 
   d="scan'208";a="603851308"
Subject: Re: [PATCH 06/12] PTI header file.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
In-Reply-To: <20110217195539.GD12172@kroah.com>
References: <james_p_freyensee@linux.intel.com>
	 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
	 <20110217192006.GA29448@kroah.com> <1297971715.3038.28.camel@localhost>
	 <20110217195539.GD12172@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 17 Feb 2011 12:13:32 -0800
Message-ID: <1297973612.3038.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 11:55 -0800, Greg KH wrote:
> On Thu, Feb 17, 2011 at 11:41:55AM -0800, J Freyensee wrote:
> > On Thu, 2011-02-17 at 11:20 -0800, Greg KH wrote:
> > > On Tue, Feb 08, 2011 at 11:34:51AM -0800, james_p_freyensee@linux.intel.com wrote:
> > > > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > 
> > > > This adds PTI header information for the PTI project.
> > > > 
> > > > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> > > > ---
> > > >  include/linux/pti.h |   38 ++++++++++++++++++++++++++++++++++++++
> > > 
> > > Why does this have to be in include/linux/?  What other files use it?
> > > 
> > > >  1 files changed, 38 insertions(+), 0 deletions(-)
> > > >  create mode 100644 include/linux/pti.h
> > > > 
> > > > diff --git a/include/linux/pti.h b/include/linux/pti.h
> > > > new file mode 100644
> > > > index 0000000..4b1c9f6
> > > > --- /dev/null
> > > > +++ b/include/linux/pti.h
> > > > @@ -0,0 +1,38 @@
> > > > +/*
> > > > + *  Copyright (C) Intel 2010
> > > > + *  Ken Mills <ken.k.mills@intel.com>
> > > 
> > > That's nice, where is Ken's signed-off-by?  We need that please.
> > > 
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or modify
> > > > + * it under the terms of the GNU General Public License version 2 as
> > > > + * published by the Free Software Foundation.
> > > > + *
> > > > + * This program is distributed in the hope that it will be useful,
> > > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > > + * GNU General Public License for more details.
> > > > + *
> > > > + * You should have received a copy of the GNU General Public License
> > > > + * along with this program; if not, write to the Free Software
> > > > + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> > > > + * USA
> > > 
> > > This paragraph is not needed, please remove it unless you are willing to
> > > keep up with the FSF's office moves for the next 40+ years.
> > > 
> > > Same goes for this paragraph on other files in this patchset, please
> > > remove it.
> > > 
> > > > + *
> > > > + */
> > > > +
> > > > +#ifndef PTI_H_
> > > > +#define PTI_H_
> > > > +
> > > > +/* basic structure used as a write address to the PTI HW */
> > > > +struct masterchannel {
> > > 
> > > Pretty generic structure name, please prefix it with "pti_"
> > > 
> > 
> > no problem, I'll fix all these.
> > 
> > > > +	u8 master;
> > > > +	u8 channel;
> > > > +};
> > > > +
> > > > +/* the following functions are defined in misc/pti.c */
> > > > +void mipi_pti_writedata(struct masterchannel *mc, u8 *cp, int count);
> > > 
> > > "cp"?
> > > 
> > 
> > All of the questions concerning these variables are described in pti.c.
> > Should have the function header comments been copied/moved here??
> 
> No, you are right, as long as you are using the proper kerneldoc
> structure for the functions there, all is fine.
> 
> > > > +struct masterchannel *mipi_request_masterchannel(u8 kerneluser);
> > > 
> > > kerneluser?
> > > 
> > > > +void mipi_release_masterchannel(struct masterchannel *mc);
> > > 
> > > "Mipi"?  What's that?
> > 
> > 'mipi' is the standard body for the PTI standard.  It's an acronymn that
> > does not stand for anything other than the Organization controlling the
> > standard: http://www.mipi.org/about-mipi/frequently-asked-questions#q2
> 
> Why not just use "pti" as that's what you are dealing with here.
> Otherwise people are going to be confused.

Good idea, I can change this and re-submit.

Thanks for the review,
Jay

> 
> thanks,
> 
> greg k-h


