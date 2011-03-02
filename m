Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab1CBVfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:35:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:45758 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394Ab1CBVfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:35:02 -0500
Date: Wed, 2 Mar 2011 16:35:44 -0500
From: Greg KH <gregkh@suse.de>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: Belisko Marek <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, acho@novell.com, error27@gmail.com
Subject: Re: [PATCH 2/2] Staging: keucr: Remove BOOLEAN type from driver.
Message-ID: <20110302213544.GA32685@suse.de>
References: <1299099845-1451-1-git-send-email-roel.vannyen@gmail.com>
 <AANLkTikQ3oBO78swv8ByBqZJjQg7jnjPJrS56W8_aWxC@mail.gmail.com>
 <20110302211813.GA1579@roel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110302211813.GA1579@roel-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:18:13PM +0100, Roel Van Nyen wrote:
> On Wed, Mar 02, 2011 at 10:12:15PM +0100, Belisko Marek wrote:
> > On Wed, Mar 2, 2011 at 10:04 PM, Roel Van Nyen <roel.vannyen@gmail.com> wrote:
> > > Remove BOOLEAN type, replacing it with bool and removing some that were not in use.
> > >
> > > Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
> > > ---
> > >  drivers/staging/keucr/common.h   |    2 --
> > >  drivers/staging/keucr/smil.h     |    4 ++--
> > >  drivers/staging/keucr/smilmain.c |    4 ++--
> > >  drivers/staging/keucr/usb.h      |    4 +---
> > >  4 files changed, 5 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
> > > index 07aabf4..5dda691 100644
> > > --- a/drivers/staging/keucr/common.h
> > > +++ b/drivers/staging/keucr/common.h
> > > @@ -1,8 +1,6 @@
> > >  #ifndef COMMON_INCD
> > >  #define COMMON_INCD
> > >
> > > -typedef u8 BOOLEAN;
> > > -
> > >  #define swapWORD(w)    ((((unsigned short)(w) << 8) & 0xff00) |        \
> > >                         (((unsigned short)(w) >> 8) & 0x00ff))
> > >  #define swapDWORD(dw)  ((((unsigned long)(dw) << 24) & 0xff000000) |   \
> > > diff --git a/drivers/staging/keucr/smil.h b/drivers/staging/keucr/smil.h
> > > index c108545..a3addff 100644
> > > --- a/drivers/staging/keucr/smil.h
> > > +++ b/drivers/staging/keucr/smil.h
> > > @@ -223,11 +223,11 @@ int         Media_D_OneSectWriteNext    (struct us_data *,u8 *);
> > >  int         Media_D_OneSectWriteFlush   (struct us_data *);
> > >
> > >  /******************************************/
> > > -void        SM_EnableLED                (struct us_data *,BOOLEAN);
> > > +void        SM_EnableLED                (struct us_data *, bool enabled);
> > >  void        Led_D_TernOn                (void);
> > >  void        Led_D_TernOff               (void);
> > >
> > > -int         Media_D_EraseAllRedtData    (u32 Index, BOOLEAN CheckBlock);
> > > +int         Media_D_EraseAllRedtData    (u32 Index);
> > Shouldn't there be something like:
> > int         Media_D_EraseAllRedtData    (u32 Index, bool CheckBlock); ???
> no, since the variable was not used in the first place.

That's fine, but don't do that in this patch.

Remember, do only one thing per patch, don't bury code changes in a
"remove typedefs" patch, that's not allowed at all.

sorry,

greg k-h
