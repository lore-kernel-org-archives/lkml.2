Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab0JEQy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:54:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55931 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab0JEQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=MK9CUSQFBvsvodOQZfS8DLsjqeYpROnYapRwDsfc8qAnLgxJ7+We4tqAft4nWLCO5x
         GF2ul9brR4USybJ9pXyWG/pAz2GnCaXCEx/YV8sqZaMVKq0lr1/VMhpO+8nJQ04R66uB
         IPxaKpl/dwhIFbFPuhvS6w14N51d90I0q1KHs=
Date: Tue, 5 Oct 2010 18:53:48 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>, nm127@freemail.hu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND/PATCH] usb: gadget: goku_udc: Fix error path
Message-ID: <20101005165348.GI5692@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg KH <gregkh@suse.de>, Rahul Ruikar <rahul.ruikar@gmail.com>,
	David Brownell <dbrownell@users.sourceforge.net>, nm127@freemail.hu,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com> <20101004122214.GA5692@bicker> <20101005132005.GB3548@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005132005.GB3548@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 06:20:05AM -0700, Greg KH wrote:
> On Mon, Oct 04, 2010 at 02:22:14PM +0200, Dan Carpenter wrote:
> > On Mon, Oct 04, 2010 at 01:29:00AM +0530, Rahul Ruikar wrote:
> > > call put_device() when device_register() fails.
> > > 
> > 
> > Sorry I didn't realize what you were trying to do here.  This is not
> > correct at all.
> > 
> > The right thing is to fix device_register() to call put_device() itself.
> > It's a bit involved, because all the callers will need to be audited but
> > someone is working on this I think.
> 
> No, no one is working on this, and no, it's not possible to make this
> type of change to the driver core as discussed in the past due to the
> way struct device can be embedded within another structure.

Sorry I guess I lost track of the discussion.  We could write a helper
macro which added the extra put device on failure?  Isn't that the more
common case anyway?  To be honest, I'm still not clear on when the extra
put_device() is appropriate and when it's not.  :/  I'll look through
the archive.

Anyway, I would prefer a slightly different patch.  The logic is easier
to follow if we keep the put_device() right next to the
device_register().  Also if we keep it in one function and we add a
helper macro later then coccinelle can rewrite it automatically.

I'll send my patch.

regards,
dan carpenter
