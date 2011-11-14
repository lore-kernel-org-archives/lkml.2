Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1KNXPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:15:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39369 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab1KNXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:15:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Subject: Re: [PATCH 2/2] devfreq: separate error paths from successful path
Date: Tue, 15 Nov 2011 00:17:41 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        =?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>
References: <1640445.17731320984574558.JavaMail.weblogic@epml10>
In-Reply-To: <1640445.17731320984574558.JavaMail.weblogic@epml10>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201111150017.41439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 11, 2011, MyungJoo Ham wrote:
> Sender : Axel Lin<axel.lin@gmail.com> Date : 2011-11-10 16:30 (GMT+09:00)
> > I think this change improves readability.
> > 
> > Signed-off-by: Axel Lin 
> 
> I agree. It makes it easier to read.
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied to linux-pm/pm-fixes.

Thanks,
Rafael


> > ---
> > drivers/devfreq/devfreq.c |   15 +++++++--------
> > 1 files changed, 7 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > index 59d24e9..c189b82 100644
> > --- a/drivers/devfreq/devfreq.c
> > +++ b/drivers/devfreq/devfreq.c
> > @@ -347,7 +347,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > if (!IS_ERR(devfreq)) {
> > dev_err(dev, "%s: Unable to create devfreq for the device. It already has one. ", __func__);
> > err = -EINVAL;
> > - goto out;
> > + goto err_out;
> > }
> > }
> > 
> > @@ -356,7 +356,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > dev_err(dev, "%s: Unable to create devfreq for the device ",
> > __func__);
> > err = -ENOMEM;
> > - goto out;
> > + goto err_out;
> > }
> > 
> > mutex_init(&devfreq->lock);
> > @@ -399,17 +399,16 @@ struct devfreq *devfreq_add_device(struct device *dev,
> >    devfreq->next_polling);
> > }
> > mutex_unlock(&devfreq_list_lock);
> > - goto out;
> > +out:
> > + return devfreq;
> > +
> > err_init:
> > device_unregister(&devfreq->dev);
> > err_dev:
> > mutex_unlock(&devfreq->lock);
> > kfree(devfreq);
> > -out:
> > - if (err)
> > - return ERR_PTR(err);
> > - else
> > - return devfreq;
> > +err_out:
> > + return ERR_PTR(err);
> > }
> > 
> > /**
> 

