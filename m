Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0G2Kka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:40:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51032 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0G2Kk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gI5ZGxC79hHtbNRmcVb2VbLKJXr9FcVCHu7QRFuMUPLGGFL+44R9ThgjoNi7yjMiFS
         X483GWGNrKBl6rhncvOAY9J2GfbBQV3UrXZherd0ZdcZaAbYt2nlhIcpvemFi34UcpGi
         Ut1m/BCpHOFd+/Q8B8nJJ5XFeQBB+YwYwcCHI=
Date: Thu, 29 Jul 2010 14:40:06 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Andrew Veliath <andrewtv@usa.net>, Jaroslav Kysela <perex@perex.cz>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] oss: msnd: check request_region() return value
Message-ID: <20100729104006.GA28465@albatros>
References: <1280335296-23475-1-git-send-email-segooon@gmail.com>
 <20100728200002.GP26313@bicker>
 <20100728212031.GQ26313@bicker>
 <s5h8w4utwod.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8w4utwod.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 12:22 +0200, Takashi Iwai wrote:
> At Wed, 28 Jul 2010 23:20:31 +0200,
> Dan Carpenter wrote:
> > 
> > On Wed, Jul 28, 2010 at 10:00:02PM +0200, Dan Carpenter wrote:
> > > This should be -EBUSY as well.  The same for "[PATCH 06/10] ALSA: msnd: 
> > > check request_region() return value"
> > > 
> > > Another way to write that would be:
> > > 
> > 
> > Gar.  I was thinking of request_resource().  request_region() returns a
> > pointer of course.
> > 
> > But still the return code should probably be -EBUSY.  Resource
> > conflicts are more likely than allocation failures.
> 
> Agreed.
> 
> Kulikov, could you rewrite the patches with -EBUSY?
No problem, patches are coming.

> 
> 
> thanks,
> 
> Takashi
> 
> > 
> > regards,
> > dan carpenter
> > 
> > > -	request_region(dev.io, dev.numio, dev.name);
> > > +	err = request_region(dev.io, dev.numio, dev.name);
> > > +	if (err) {
> > > +		free_irq(dev.irq, &dev);
> > > +		return err;
> > > +	}
> > > 
> > > regards,
> > > dan carpenter
> > > 
> > > > +	if (request_region(dev.io, dev.numio, dev.name) == NULL) {
> > > > +		free_irq(dev.irq, &dev);
> > > > +		return -ENOMEM;
> > > > +	}
> > 
