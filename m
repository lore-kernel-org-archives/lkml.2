Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1BSBCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 20:02:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab1BSBCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 20:02:47 -0500
Date: Fri, 18 Feb 2011 17:02:30 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Message-ID: <20110219010230.GA2402@suse.de>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com>
 <20110218211423.GH796@kroah.com>
 <6E21E5352C11B742B20C142EB499E048011604@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110218220724.GA28986@suse.de>
 <6E21E5352C11B742B20C142EB499E04801162F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110218222916.GA14244@suse.de>
 <6E21E5352C11B742B20C142EB499E048011693@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048011693@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 12:56:16AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Friday, February 18, 2011 5:29 PM
> > To: KY Srinivasan
> > Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org
> > Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> > 
> > On Fri, Feb 18, 2011 at 10:16:05PM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Greg KH [mailto:gregkh@suse.de]
> > > > Sent: Friday, February 18, 2011 5:07 PM
> > > > To: KY Srinivasan
> > > > Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > > virtualization@lists.osdl.org
> > > > Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> > > >
> > > > On Fri, Feb 18, 2011 at 10:00:04PM +0000, KY Srinivasan wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Greg KH [mailto:greg@kroah.com]
> > > > > > Sent: Friday, February 18, 2011 4:14 PM
> > > > > > To: KY Srinivasan
> > > > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > > > > > Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> > > > > >
> > > > > > On Tue, Feb 15, 2011 at 11:55:35AM -0800, K. Y. Srinivasan wrote:
> > > > > > >
> > > > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > > > > >
> > > > > > You didn't run this through checkpatch.pl.
> > > > > >
> > > > > > Please do so and fix the warning it gives you.
> > > > > Greg, I did run the checkpatch script against this patch and the only
> > > > > complaint I got was with regards to the IRQF_SAMPLE_RANDOM flag that I
> > > > > pass. As a virtual machine, this is the only external event that the
> > > > > VM is going to see and so I chose to keep this flag.  Is there
> > > > > something that would replace this flag; looking at the Xen drivers
> > > > > they do pass this flag.
> > > >
> > > > But that flag is going away, right?  And this really can't be a valid
> > > > source of entropy as the HV channel is pretty predictable.
> > >
> > > Is it going away? What would replace this. Is all interrupt sources considered
> > > predictable?
> > 
> > Did you read the file that the checkpatch script told you to about this
> > entry?
> 
> It is only after reading the document, I decided to keep that flag. Please
> note this is not a question of some interrupt sources not being 
> a good source of entropy; for this VM this is the only source of interrupts.
> The document on this flag talked about how people were incorrectly
> marking their interrupt as an entropy source; in this case there is not much of a
> choice. 
> 
> > 
> > > This is the only unpredictable thing happening in the VM and that is the reason
> > > I chose to keep the flag.
> > 
> > If you remove it, do we loose all entropy for the VM?
> > 
> > > > If you are only using this because Xen does/did it, that's not a valid
> > > > excuse :)
> > > Surely, you are joking.
> > 
> > Not at all.
> 
> To set the record straight here, this flag is in the existing code.
> After I ran checkpatch, I toyed with the idea of getting rid of this. Then I 
> decided to keep it for all the reasons I mentioned earlier. 
> 
> > 
> > > In any event I am sending you a new patch with that flag removed.
> > 
> > Have you tested to see if you now loose all entropy, and it causes
> > problems or not?
> 
> I am glad you asked me to test it. When I remove this flag, the entropy goes down 
> significantly and this is not surprising. Looking at 
> /proc/sys/kernel/entropy/entropy_avail, with the original patch after a couple
> of compiles the number would be in thousands. With that flag removed,
> I have the VM up for about an hour, even after a couple of compiles,
> the entropy number is yet to crack 200.
> 
> Let me know how you want to proceed here.

Ok, my fault, let's keep the original flag.  Care to resend the patch
you had originally sent?

thanks,

greg k-h
