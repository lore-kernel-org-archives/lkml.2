Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab0GNTGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:06:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45256 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab0GNTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ch1faFVaI6OPk9LzvS0MqmX1udzvnMEIQzEQez2Zl4L4VG2t+KyHCff9tztJQkQdbK
         V2EukZrMciw6K6qxlWvEKTRUMdCgSrCVKbpLCd6EZmNQdwG69nrBUISJ0Msn6CMb1cFP
         59dJNgw6ZQPXvLFP5JCF/dqrhw5+a+Su0bcUg=
Date: Wed, 14 Jul 2010 23:05:38 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Julia Lawall <julia@diku.dk>, Frederic Weisbecker <fweisbec@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: dpt_i2o: fix memory leak
Message-ID: <20100714190538.GA4616@albatros>
References: <1279130008-9934-1-git-send-email-segooon@gmail.com>
 <20100714185831.GA5164@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714185831.GA5164@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 20:58 +0200, Dan Carpenter wrote:
> On Wed, Jul 14, 2010 at 09:53:27PM +0400, Kulikov Vasiliy wrote:
> > Free allocated memory if adpt_ioctl_to_context() failed.
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > ---
> >  drivers/scsi/dpt_i2o.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> > index f2d4df1..dd9a43b 100644
> > --- a/drivers/scsi/dpt_i2o.c
> > +++ b/drivers/scsi/dpt_i2o.c
> > @@ -1839,8 +1839,10 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
> >  	sg_offset = (msg[0]>>4)&0xf;
> >  	msg[2] = 0x40000000; // IOCTL context
> >  	msg[3] = adpt_ioctl_to_context(pHba, reply);
> 
> This patch is wrong I'm afraid.  adpt_ioctl_to_context() frees "reply" if
> there is an error.
Hmm right, but it is very strange coding style - function frees resources
that it did not allocated on error and does not free them on success.

Please, ignore this patch. Sorry for the noise.
