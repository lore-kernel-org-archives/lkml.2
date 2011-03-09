Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1CIQ7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:59:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45728 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab1CIQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:59:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L5hYv0HSUPc/QP0JPoLUNmdm5unWw8688FTHFrBhSFJ+P35f7HUek1BhZodT3AVrGD
         dTBO6FS7MhOKZeABES0x+ivPiQ4jR9f7KFHwXIQe66nnUE9hmRuEhDFh2e+Rs187g7Tr
         aNjF63xlAaEBgKfWcWublikSkuisDDydfliz0=
Date: Wed, 9 Mar 2011 17:58:58 +0100
From: Tejun Heo <tj@kernel.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCH 10/16] ub: Convert to bdops->check_events()
Message-ID: <20110309165858.GE27010@htj.dyndns.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
 <1299662016-7721-11-git-send-email-tj@kernel.org>
 <20110309094658.29c7fa54@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309094658.29c7fa54@lembas.zaitcev.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 09:46:58AM -0700, Pete Zaitcev wrote:
> On Wed,  9 Mar 2011 10:13:30 +0100
> Tejun Heo <tj@kernel.org> wrote:
> 
> > +++ b/drivers/block/ub.c
> > @@ -1788,7 +1788,8 @@ static int ub_bd_revalidate(struct gendisk *disk)
> >   *
> >   * The return code is bool!
> >   */
> > -static int ub_bd_media_changed(struct gendisk *disk)
> > +static unsigned int ub_bd_check_events(struct gendisk *disk,
> > +				       unsigned int clearing)
> 
> > -	return lun->changed;
> > +	return lun->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
> >  }
> 
> Return code is not so bool anymore. The comment meant that usually
> "int" means "return 0 on success, -1 on failure, maybe some integer
> for a tricky condition" but not here. I'll have the comment fixed up,
> or if you want you do it.

Ooh, right.  Please go ahead and fix that up.

Thank you.

-- 
tejun
