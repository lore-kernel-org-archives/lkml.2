Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2IMP1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:27:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39697 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab2IMP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:27:46 -0400
Date: Thu, 13 Sep 2012 18:27:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bruce Humphrey <brucehum@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: Comedi: dyna_pci10xx: Replace printk with
 dev_info
Message-ID: <20120913152717.GA4587@mwanda>
References: <1347500760-4394-1-git-send-email-brucehum@gmail.com>
 <20120913080041.GI19396@mwanda>
 <CAGzQFLgLkqOdfQjbz3LFArEZGxwiEA4nnpLLtCHaX3w=-=RbKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGzQFLgLkqOdfQjbz3LFArEZGxwiEA4nnpLLtCHaX3w=-=RbKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:46:02PM +0200, Bruce Humphrey wrote:
> Thanks for all the comments!
> 
> My own answers are from the complete linux kernel newbie point of view!
> That's why I'm writing them even if they seem obvious, to make sure.
> 
>  >               data[n] = 0;
> > > -             printk(KERN_DEBUG "comedi: dyna_pci10xx: "
> > > -                     "timeout reading analog input\n");
> > > +             dev_dbg(dev->class_dev, "timeout reading analog input\n");
> >
> > The trick with removing the "comedi: dyna_pci10xx: " prefix is that
> > you need to put this at the top of the file before the includes.
> >
> > #define pr_fmt(fmt) "comedi: dyna_pci10xx: " fmt
> >
> > You would need to remove the prefix from the other pr_info printk
> > as well so it's not included twice.
> >
> 
> Thanks for the very useful info!
> This would use pr_info, and not dev_info, which I think is prefered. But of
> course, pr_info is much better than printk, coding style wise.
> 

Sorry, for some reason I thought there was an existing pr_info() in
the file which would have needed to be updated.  I'm not sure what
I was looking at...

Anyway, this file has changed recently in linux-next so there is
only one printk() left now.

regards,
dan carpenter

