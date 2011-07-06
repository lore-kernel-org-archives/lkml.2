Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1GFPCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:02:21 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33752 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab1GFPCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:02:20 -0400
X-Sasl-enc: oLepzBoeDz3zBvXNi1vcfES5BmgUjksunPnF22w8foua 1309964539
Date: Wed, 6 Jul 2011 08:02:02 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 15/77] Staging: hv: blkvsc: Add the appropriate
 MODULE_ALIAS() line
Message-ID: <20110706150202.GA3353@kroah.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-15-git-send-email-kys@microsoft.com>
 <20110705160621.GC7214@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D27E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110706034228.GA4291@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D414@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480816D414@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 02:55:12PM +0000, KY Srinivasan wrote:
> > > I think you mean MODULE_DEVICE_TABLE()?
> > 
> > Yes, sorry for the typo.
> > 
> > > I actually went down that path first
> > > adding code  to  file2alias.c for parsing the vmbus ID table. Given that this
> > approach
> > > would make it  impossible to support auto-loading of these drivers
> > > on many of the released kernels,
> > 
> > Wait, what?  What is a "released kernel"?  We are working on the
> > in-kernel patch, we don't care about older distros/releases for this
> > work at all.  Also, it doesn't make sense at all, why would the change I
> > asked for make any difference on older distros/kernels?
> 
> I understand we don't care here about older kernels and I will do what you
> have suggested. I just wanted to give you the rationale for choices I made:
> We are currently supporting older distros/kernels using these upstream bits.
> With the MODULE_ALIAS() approach, since I did not have to change any code
> outside the hv directory, this was possible. I was mostly concerned about 
> having to make changes to code outside the hv directory and figuring out 
> how to build and propagate these changes (file2alias.c) in older kernels. 

You create a patch like any other patch and give it to the people who
are stuck with those older kernels.  It shouldn't be that hard, and it
also shouldn't be something that matters for this mainline work either.

> > > I chose to go with the MODULE_ALIAS() macro that did not need any
> > > changes outside our drivers. In both methods, the formatting of the
> > > name is bus specific since I would be writing the code to parse the
> > > table in file2alias.c.
> > 
> > Yes, that is what is needed to be done.
> > 
> > > Granted, I have been quite unimaginative in my alias names, but I
> > > thought they were reasonably descriptive. If at all possible, for the
> > > reasons listed above, I would prefer to use the MODULE_ALIAS() macro
> > > (I could embed all or part of the guid in the alias). Let me know.
> > 
> > Please do the correct thing and use MODULE_DEVICE_TABLE().
> 
> We have four drivers now excluding vmbus and soon we will have only three
> drivers with the merge of block and stor drivers. Would you still recommend I use the
> full guid to name these drivers.

Yes, why not?

> Rather than embedding the entire 128bit guid in module aliases, I was
> thinking of setting up a more reasonable namespace for these drivers
> (like what virtio has done for instance). Let me know if this is ok
> with you if I took that route (mapping the guid to small integers and
> having these integers be used in alias strings).

What's the big deal of having a large number as an alias?  Is there some
constraint here that I am not aware of?

greg k-h
