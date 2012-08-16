Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380Ab2HPT4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:56:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab2HPT4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:56:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
Date: Thu, 16 Aug 2012 22:02:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, David Miller <davem@davemloft.net>
References: <Pine.LNX.4.44L0.1208161232001.31195-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208161232001.31195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208162202.40929.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 16, 2012, Alan Stern wrote:
> On Thu, 16 Aug 2012, Miklos Szeredi wrote:
> 
> > Yes, this appears to work.  Following patch fixes the suspend oops.
> > 
> > Thanks,
> > Miklos

OK

Miklos, can you please send that to Dave with a proper changelog and
sign-off (please add my ACK too)?  Please make it clear that this is a
regression fix and which commit has introduced the regression.

> > ---
> >  drivers/ide/ide-pm.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
> > index 9240609..8d1e32d 100644
> > --- a/drivers/ide/ide-pm.c
> > +++ b/drivers/ide/ide-pm.c
> > @@ -4,7 +4,7 @@
> >  
> >  int generic_ide_suspend(struct device *dev, pm_message_t mesg)
> >  {
> > -	ide_drive_t *drive = dev_get_drvdata(dev);
> > +	ide_drive_t *drive = to_ide_device(dev);
> >  	ide_drive_t *pair = ide_get_pair_dev(drive);
> >  	ide_hwif_t *hwif = drive->hwif;
> >  	struct request *rq;
> > @@ -40,7 +40,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
> >  
> >  int generic_ide_resume(struct device *dev)
> >  {
> > -	ide_drive_t *drive = dev_get_drvdata(dev);
> > +	ide_drive_t *drive = to_ide_device(dev);
> >  	ide_drive_t *pair = ide_get_pair_dev(drive);
> >  	ide_hwif_t *hwif = drive->hwif;
> >  	struct request *rq;
> 
> And now you can get rid of the useless dev_set_drvdata() call.

That was in the other patch I think.

Thanks,
Rafael
