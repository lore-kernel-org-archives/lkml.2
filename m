Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab1CBVSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:18:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64607 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab1CBVSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UE+/fVBUhsaCK0haG3QUhIDz2GMt/FbyIlQ1fboLULxHP+eg9ZhUTJExghrprxQwEn
         PKERv6n4mH0rcHlGTPpu9RqO6rLjW1ww+wgrCyEs2HpR751VQdFyfelel2bVFLZyjw0e
         Ei9jx1rY/7VW3N2CseZv3rKqGWRTsJM+Yzjo8=
Date: Wed, 2 Mar 2011 22:18:13 +0100
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        acho@novell.com, error27@gmail.com
Subject: Re: [PATCH 2/2] Staging: keucr: Remove BOOLEAN type from driver.
Message-ID: <20110302211813.GA1579@roel-laptop>
References: <1299099845-1451-1-git-send-email-roel.vannyen@gmail.com>
 <AANLkTikQ3oBO78swv8ByBqZJjQg7jnjPJrS56W8_aWxC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikQ3oBO78swv8ByBqZJjQg7jnjPJrS56W8_aWxC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:12:15PM +0100, Belisko Marek wrote:
> On Wed, Mar 2, 2011 at 10:04 PM, Roel Van Nyen <roel.vannyen@gmail.com> wrote:
> > Remove BOOLEAN type, replacing it with bool and removing some that were not in use.
> >
> > Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
> > ---
> >  drivers/staging/keucr/common.h   |    2 --
> >  drivers/staging/keucr/smil.h     |    4 ++--
> >  drivers/staging/keucr/smilmain.c |    4 ++--
> >  drivers/staging/keucr/usb.h      |    4 +---
> >  4 files changed, 5 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
> > index 07aabf4..5dda691 100644
> > --- a/drivers/staging/keucr/common.h
> > +++ b/drivers/staging/keucr/common.h
> > @@ -1,8 +1,6 @@
> >  #ifndef COMMON_INCD
> >  #define COMMON_INCD
> >
> > -typedef u8 BOOLEAN;
> > -
> >  #define swapWORD(w)    ((((unsigned short)(w) << 8) & 0xff00) |        \
> >                         (((unsigned short)(w) >> 8) & 0x00ff))
> >  #define swapDWORD(dw)  ((((unsigned long)(dw) << 24) & 0xff000000) |   \
> > diff --git a/drivers/staging/keucr/smil.h b/drivers/staging/keucr/smil.h
> > index c108545..a3addff 100644
> > --- a/drivers/staging/keucr/smil.h
> > +++ b/drivers/staging/keucr/smil.h
> > @@ -223,11 +223,11 @@ int         Media_D_OneSectWriteNext    (struct us_data *,u8 *);
> >  int         Media_D_OneSectWriteFlush   (struct us_data *);
> >
> >  /******************************************/
> > -void        SM_EnableLED                (struct us_data *,BOOLEAN);
> > +void        SM_EnableLED                (struct us_data *, bool enabled);
> >  void        Led_D_TernOn                (void);
> >  void        Led_D_TernOff               (void);
> >
> > -int         Media_D_EraseAllRedtData    (u32 Index, BOOLEAN CheckBlock);
> > +int         Media_D_EraseAllRedtData    (u32 Index);
> Shouldn't there be something like:
> int         Media_D_EraseAllRedtData    (u32 Index, bool CheckBlock); ???
no, since the variable was not used in the first place.
> 
> >  //u32       Media_D_GetMediaInfo        (struct us_data * fdoExt, PIOCTL_MEDIA_INFO_IN pParamIn, PIOCTL_MEDIA_INFO_OUT pParamOut);
> >
> >  //----- SMILSub.c ----------------------------------------------------
> > diff --git a/drivers/staging/keucr/smilmain.c b/drivers/staging/keucr/smilmain.c
> > index 64f2d51..3c035d2 100644
> > --- a/drivers/staging/keucr/smilmain.c
> > +++ b/drivers/staging/keucr/smilmain.c
> > @@ -527,7 +527,7 @@ int Media_D_OneSectWriteFlush(PFDO_DEVICE_EXTENSION fdoExt)
> >  //
> >  ////LED Tern On/Off Subroutine
> >  ////----- SM_EnableLED() -----------------------------------------------
> > -//void SM_EnableLED(PFDO_DEVICE_EXTENSION fdoExt, BOOLEAN enable)
> > +//void SM_EnableLED(PFDO_DEVICE_EXTENSION fdoExt)
> >  //{
> >  //    if (fdoExt->Drive_IsSWLED)
> >  //    {
> > @@ -1778,7 +1778,7 @@ int MarkFail_D_PhyOneBlock(struct us_data *us)
> >  //}
> >  //
> >  ////----- Media_D_EraseAllRedtData() -----------------------------------
> > -//int Media_D_EraseAllRedtData(u32 Index, BOOLEAN CheckBlock)
> > +//int Media_D_EraseAllRedtData(u32 Index, bool CheckBlock)
> >  //{
> >  //    u8    i;
> >  //
> > diff --git a/drivers/staging/keucr/usb.h b/drivers/staging/keucr/usb.h
> > index 154ec9e..a85b20f 100644
> > --- a/drivers/staging/keucr/usb.h
> > +++ b/drivers/staging/keucr/usb.h
> > @@ -199,10 +199,8 @@ struct us_data {
> >        u8        MMC_HIGH_CAPACITY;
> >
> >        //----- MS Control Data ----------------
> > -       BOOLEAN             MS_SWWP;
> >        u32               MSP_TotalBlock;
> >        MS_LibControl       MS_Lib;
> > -       BOOLEAN             MS_IsRWPage;
> >        u16                MS_Model;
> >
> >        //----- SM Control Data ----------------
> > @@ -215,7 +213,7 @@ struct us_data {
> >        int             SrbStatus;
> >
> >        //------Power Managerment ---------------
> > -       BOOLEAN         Power_IsResum;
> > +       bool         Power_IsResum;
> >  };
> >
> >  /* Convert between us_data and the corresponding Scsi_Host */
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> -- 
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
> 
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> icq: 290551086
> web: http://open-nandra.com
