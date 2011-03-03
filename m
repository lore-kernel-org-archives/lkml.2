Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1CCGWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:22:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab1CCGWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:22:51 -0500
Date: Wed, 2 Mar 2011 22:10:02 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 4/6] Staging: hv:  Unify the hyperv driver abstractions
Message-ID: <20110303061002.GD32209@suse.de>
References: <1298686023-30892-1-git-send-email-kys@microsoft.com>
 <20110301025230.GE1663@kroah.com>
 <6E21E5352C11B742B20C142EB499E04801661A@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110302054125.GB28382@kroah.com>
 <6E21E5352C11B742B20C142EB499E048016A13@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048016A13@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 02:50:00AM +0000, KY Srinivasan wrote:
> > > > "struct driver_context"?  Oh please no.
> > >
> > > Greg; this is the patch that consolidates the state in  struct hv_driver into
> > > struct driver_context. In the spirit of doing one thing in a patch;
> > > other relevant changes are made in:
> > > Patch[5/6]: Changes the name driver_context to hyperv_driver
> > > Patch[6/6]: Cleanup all variable names that refer to struct hyperv_driver.
> > 
> > Yes, but on its own, this patch is wrong, that is not a valid name, even
> > if it is a "temporary" name.
> 
> Greg, the temporary name happens to be the name currently in use in the 
> code - this is not the name I introduced.

There is not a "struct driver_context" in the code that I see today, or
am I missing something?  That's my objection here, please don't use that
name, it's not valid for a subsystem to use, even for a tiny bit.

> Think of this as the surviving data structure after  the hv_driver
> state is consolidated into (the existing) driver_context data
> structure.  I did this in the spirit of doing one thing at a time. If
> I am going to be picking a more appropriate name for the consolidated
> data structure; I might as well pick the final name that we want this
> unified driver abstraction to be called. 

Your final name is fine, it's the intermediate one I'm objecting to.

How about 'struct hv_driver_context' instead?

> > > > I realize that you are hopefully going to later rename this to something
> > > > else, but remember, a few patches back you thought that the "ctx" name
> > > > wasn't nice.  And here you go resuscitating it from the graveyard of
> > > > pointy bits.
> > >
> > > As I noted in a different email, may be the granularity I chose in breaking up
> > > these patches is causing all this confusion.
> > 
> > Yes, as I think you need to go much finer as you were doing more than
> > one thing in these patches, and not describing them properly at all.
> > 
> > Please try to redo them in a simpler manner, probably breaking it into
> > more steps, so we can properly review them.
> 
> Based on your comments on intermediate names, would you recommend that
> as part  of consolidating the driver abstractions, I also rename this combined 
> state. 

Probably, if I understand what you are referring to.  Please post code
so that I really know what you are doing :)

thanks,

greg k-h
