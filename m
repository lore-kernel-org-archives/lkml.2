Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0LXLDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:03:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58194 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab0LXLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kvn5BdFHkMriinCZ7zf9WUD5k4ruSWo2zFAGR584qOAzxFI2JN3QIXYs2peIa+xnco
         f7cVYmAy/KYKoRRxRcG1ZhzgAugX8YuoE8TkvElrJgqboo4RpKYfWHXlsEtz4mCDiOWH
         VSIHRp5zMklaPnzwhm2mt30xbtBDfKPkPuZAY=
Date: Fri, 24 Dec 2010 12:03:27 +0100
From: Tejun Heo <htejun@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Boot failure with block/for-next
Message-ID: <20101224110327.GB8781@htj.dyndns.org>
References: <1293038823.3019.89.camel@mulgrave.site>
 <1293078673.3019.765.camel@mulgrave.site>
 <20101223100956.GA15625@htj.dyndns.org>
 <1293118041.3029.3.camel@mulgrave.site>
 <20101223155239.GB18482@htj.dyndns.org>
 <1293120614.7776.0.camel@mulgrave.site>
 <20101223161312.GC18482@htj.dyndns.org>
 <1293128717.7776.68.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293128717.7776.68.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On Thu, Dec 23, 2010 at 12:25:17PM -0600, James Bottomley wrote:
> On Thu, 2010-12-23 at 17:13 +0100, Tejun Heo wrote:
> > On Thu, Dec 23, 2010 at 10:10:14AM -0600, James Bottomley wrote:
> > > > Can you please apply the debug patch I posted in the other message and
> > > > post the boot log?  Let's see how the partition read is failing.
> > > 
> > > That's actually a red herring ... the disk isn't spinning up, so the
> > > partition read is getting a not ready.
> > 
> > Oh, yay, but at any rate I think the don't-clear-media-presence patch
> > is probably a good idea just in case UA gets reported somehow.
> 
> Well, it wasn't this either.  It turns out that this disk alone reports
> UNIT_ATTENTION RESET_OCCURRED on the first TEST UNIT READY of spin up.
> Ordinarily this is harmless, but the new medium change code wrongly
> interprets any UNIT_ATTENTION as medium changed (and then refuses to
> talk to the disk).  This is actually a change from the previous code, so
> the fix is to put it back the way it was.

I see.  I wonder why the previous patch didn't work.  It should have
had about the same effect.  I think the UA change went in there while
trying to bring sr and sd behaviors closer to each other, but yes it
seems the original code didn't have that.  That said, now there are
paths where UA would be consumed without setting ->changed and thus sd
may miss media change events.  This has been like this for quite some
time and there aren't many removable sd devices these days, so maybe
this doesn't matter too much.

Anyways, for now, the change looks good to me too.  Thanks.

-- 
tejun
