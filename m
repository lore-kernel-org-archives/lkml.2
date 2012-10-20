Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab2JTCat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 22:30:49 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55262 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2JTCas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 22:30:48 -0400
Subject: Re: [PATCH] [PATCH] extcon: driver model release call not needed
From: anish kumar <anish198519851985@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <508204FC.4030802@samsung.com>
References: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
	 <508204FC.4030802@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Oct 2012 11:30:37 +0900
Message-ID: <1350700237.3764.156.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 10:57 +0900, Chanwoo Choi wrote:
> On 10/19/2012 02:12 AM, anish kumar wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > 
> > We don't need a release call in this file as we are doing
> > everything needed in unregister call and we don't have any
> > more pointer to free up.
> > 
> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
> > ---
> >  drivers/extcon/extcon-class.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> > index 946a318..cf30eb1 100644
> > --- a/drivers/extcon/extcon-class.c
> > +++ b/drivers/extcon/extcon-class.c
> > @@ -585,9 +585,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
> >  
> >  static void extcon_dev_release(struct device *dev)
> >  {
> > -	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
> > -
> > -	extcon_cleanup(edev, true);
> > +	/* We don't have any thing to free here */
> >  }
> >  
> >  static const char *muex_name = "mutually_exclusive";
> 
> I can't agree this patch. The extcon_dev_release() function is used
> for dev->release. If some case without calling extcon_dev_unregister(),
> I think dev->release function is needed to free memory of edev->dev.
Is it not being released by extcon_dev_unregister?
I think it is released by that and we will do two times free and
list_del(&edev->entry) as it is called by extcon_dev_release also.
> 
> The edev->dev->release store the function pointer of extcon_dev_release()
> in extcon_dev_register().
> edev->dev->parent = dev;
> edev->dev->class = extcon_class;
> edev->dev->release = extcon_dev_release;
> 
> 
> Thanks,
> Chanwoo Choi


