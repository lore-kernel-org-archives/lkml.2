Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2HFSRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:17:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33380 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2HFSRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:17:48 -0400
Date: Mon, 6 Aug 2012 21:17:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: devel@driverdev.osuosl.org, Devendra Naga <devendra.aaru@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Javier =?iso-8859-1?Q?Mu=F1oz?= <jmunhoz@igalia.com>
Subject: Re: [PATCH] staging: sm7xxfb: copy name of the device before calling
 smtc_alloc_fb_info
Message-ID: <20120806181729.GP4352@mwanda>
References: <1344100872-19640-1-git-send-email-develkernel412222@gmail.com>
 <20120806141248.GN4352@mwanda>
 <CA+C2MxQ1327Y+Fn+pFwE_bizOmT5WN2EericQL9dmPEeckuM+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+C2MxQ1327Y+Fn+pFwE_bizOmT5WN2EericQL9dmPEeckuM+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 09:57:52PM +0545, Devendra Naga wrote:
> On Mon, Aug 6, 2012 at 7:57 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Sat, Aug 04, 2012 at 11:06:12PM +0545, Devendra Naga wrote:
> >> as we do a strcpy(smdrv_ptr->fb_struct->fix->id, name), and the name here in
> >> sm7xxx_probe is not having any assignment, and which leads to copying of the garbage value
> >> into the id field of the fix struct of fb interface struct. fix it by copying the name before
> >> calling alloc_fbinfo
> >>
> >> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> >> ---
> >>  Only compile tested
> >>  This patch is not tested using the hardware... if any one is having this hardware, i request them to
> >> please test this
> >>  drivers/staging/sm7xxfb/sm7xxfb.c |    7 ++++---
> >>  1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
> >> index 1c1780c..d3957ef 100644
> >> --- a/drivers/staging/sm7xxfb/sm7xxfb.c
> >> +++ b/drivers/staging/sm7xxfb/sm7xxfb.c
> >> @@ -798,16 +798,17 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
> >>       if (err)
> >>               return err;
> >>
> >> +     sprintf(name, "sm%Xfb", ent->device);
> >> +
> >>       sfb = smtc_alloc_fb_info(pdev, name);
> >>
> >> +     sfb->chip_id = ent->device;
> >> +
> >>       if (!sfb) {
> >
> > Thanks for fixing this, and well done for spotting the bug.
> >
> Thanks Dan...
> 
> > There is a dereference before the check here, but I see you resent
> > this in another thread.  Next time could you respond to the
> > original with a message which says to not apply it.
> >
> Sure but i have a doubt.
> 
> since we do V++ after every change to the sent patch , do we really
> need to say that please dont apply this patch and there's one more
> patch coming with fix?

Yes.  The second email very far away from the first one if you are
subscribed to a bunch of high traffic email lists.

I reviewed your patch.  I saw the bug.  I saw that no one else had
replied to your email.  I almost didn't notice the v2 email.  It's
annoying.  It's not hard to just send an email.  "Oops.  There is
a bug here.  I'll sent a v2."

regards,
dan carpenter

