Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1BWMRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:17:46 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58214 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab1BWMRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LT5X7D91IyAqC6xBgQJhlz0TBE8UR2svFwZRpUDkjB1hF6XK5B/YUmHnTJc57ukKWg
         SY8ZHGpNgPHUkjIN39lV0Og1isVfQvTW55wk2gl/01zIbthBBGm6ZeKl3HOMOYiOQJoH
         s6OI0tV1LjTCczW+1gOqTmfGkDS6VwuDrbZt8=
Date: Wed, 23 Feb 2011 15:17:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, devel@driverdev.osuosl.org,
        cota@braap.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: vme: remove unreachable code
Message-ID: <20110223121726.GR1898@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Martyn Welch <martyn.welch@ge.com>,
	Manohar Vanga <manohar.vanga@cern.ch>, devel@driverdev.osuosl.org,
	cota@braap.org, linux-kernel@vger.kernel.org
References: <1298403376-28352-1-git-send-email-manohar.vanga@cern.ch>
 <1298403376-28352-2-git-send-email-manohar.vanga@cern.ch>
 <4D64D10A.3070702@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D64D10A.3070702@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:19:06AM +0000, Martyn Welch wrote:
> On 22/02/11 19:36, Manohar Vanga wrote:
> > Remove unreachable code from vme_register_bridge
> > 
> > Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Please always CC the list.  It's going to be Greg to commit this
code so CC Greg as well.

./scripts/get_maintainer.pl patch.diff

(Although you should generally remove Tejun from the CC list.)

> 
> Yeah - that's there from development. If the function needed to be extended,
> that's the next part of the error path.

Don't do that.  Kernel style is austere.  Anything that isn't needed
here and now should be removed.

> > --- a/drivers/staging/vme/vme.c
> > +++ b/drivers/staging/vme/vme.c
> > @@ -1363,7 +1363,6 @@ int vme_register_bridge(struct vme_bridge *bridge)
> >  
> >  	return retval;
> >  
> > -	i = VME_SLOTS_MAX;
> >  err_reg:
> >  	while (i > -1) {
> >  		dev = &bridge->dev[i];

There are two problems with this loop.  1) It unregisters the device
which failed to register.  2) It is a forever loop.

It should be:
	while (--i >= 0) {
		dev = &bridge->dev[i];

Can you fix that up as well and resend.

regards,
dan carpenter
