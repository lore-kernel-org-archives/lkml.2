Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1CBFri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:47:38 -0500
Received: from kroah.org ([198.145.64.141]:35700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1CBFrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:47:37 -0500
Date: Wed, 2 Mar 2011 00:41:25 -0500
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 4/6] Staging: hv:  Unify the hyperv driver abstractions
Message-ID: <20110302054125.GB28382@kroah.com>
References: <1298686023-30892-1-git-send-email-kys@microsoft.com>
 <20110301025230.GE1663@kroah.com>
 <6E21E5352C11B742B20C142EB499E04801661A@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E04801661A@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 01:43:13AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Monday, February 28, 2011 9:53 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> > Janssen
> > Subject: Re: [PATCH 4/6] Staging: hv: Unify the hyperv driver abstractions
> > 
> > On Fri, Feb 25, 2011 at 06:07:03PM -0800, K. Y. Srinivasan wrote:
> > > This patch combines the two driver abstractions into
> > > a single driver abstraction.
> > 
> > Ah, how sweet.  Unfortunatly you don't say "how" you did this.
> > 
> > Nor do you describe _what_ those two driver abstractions were.  Are we
> > talking i2c and usb abstractions?  gpio and spi?  Driver core and
> > platform?  We want to know exactly what is going on here.
> 
> My mistake; I will have a more descriptive comment.
> 
> > 
> > Think of writing something that when you look back, in 3 years, while
> > staring at a Linux hyperv driver originally written for the 2.6.9
> > kernel, that somehow never got forward ported and you are tasked with
> > doing this, that you can just do a simple 'git log drivers/staging/hv/'
> > and instantly know just from the changelog comments exactly what you
> > need to do to your driver to clean it up and properly get it to work on
> > the new 8.2.2 kernel release.
> > 
> > This changelog entry, would require you to go and dig through the guts
> > of the patch itself, trying to figure out what abstractions you are
> > talking about, and exactly how they were combined, all the while
> > wondering _why_ they were combined.
> > 
> > Please, think of your future self, you will thank him in the years to
> > come by doing this properly.  Not to mention making other's lives easier
> > if you happen to have escaped this dire task by then.
> > 
> > Oh, you have an extra space up there in the subject, please fix it next
> > time.
> > 
> > > -int blk_vsc_initialize(struct hv_driver *driver)
> > > +int blk_vsc_initialize(struct driver_context *driver)
> > 
> > "struct driver_context"?  Oh please no.
> 
> Greg; this is the patch that consolidates the state in  struct hv_driver into 
> struct driver_context. In the spirit of doing one thing in a patch;
> other relevant changes are made in:
> Patch[5/6]: Changes the name driver_context to hyperv_driver
> Patch[6/6]: Cleanup all variable names that refer to struct hyperv_driver.

Yes, but on its own, this patch is wrong, that is not a valid name, even
if it is a "temporary" name.

> > I realize that you are hopefully going to later rename this to something
> > else, but remember, a few patches back you thought that the "ctx" name
> > wasn't nice.  And here you go resuscitating it from the graveyard of
> > pointy bits.
> 
> As I noted in a different email, may be the granularity I chose in breaking up
> these patches is causing all this confusion.

Yes, as I think you need to go much finer as you were doing more than
one thing in these patches, and not describing them properly at all.

Please try to redo them in a simpler manner, probably breaking it into
more steps, so we can properly review them.

> > And what happens if your future patch is rejected?  You are stuck with a
> > "driver_context" structure in a subsystem?  That's a pretty big abuse of
> > the global namespace, don't you think?  It sounds like something that
> > should go into include/linux/device.h
> > 
> > Please be careful about names, they mean things, even when you think
> > they don't.
> 
> Greg, would it be better if I just had one patch for dealing with all
> device related issues and a Separate patch for dealing all driver
> related issues?

Again, only do one thing per patch.  So yes, of course they should be
separate.

thanks,

greg k-h
