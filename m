Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0IISzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:55:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54865 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0IISzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=N45AytBadk79BSsCMvDQ+GP0UR2fTXUJ3/Mn3zIVPs2o6R7Y3/riUUtTcAzjcLpGPE
         Qqt+EoX+mpklw6BXh3700Bbgc9iQqJ8wN5ViS+OUdr2XlgK2rXzzNnvhHKvVmKlx7Ggj
         DoFX2rgsHXTv67gyapeq47qQHXF+n4aKhKR4Q=
Date: Thu, 9 Sep 2010 19:56:00 +0100
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: Charles =?utf-8?Q?Cl=C3=A9ment?= <caratorn@gmail.com>
Cc: gregkh@suse.de, more.andres@gmail.com, lieb@canonical.com,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers/staging/vt6656: use ARRAY_SIZE macro in
 channel.c
Message-ID: <20100909185600.GA2252@vostro.config>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
 <1283981275-5098-1-git-send-email-nikitasangelinas@gmail.com>
 <20100909092915.GA4994@air>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100909092915.GA4994@air>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 11:29:35AM +0200, Charles Clément wrote:
> I think this definition is not used anywhere in the driver and thus can
> be removed.
> 
> On Wed, Sep 08, 2010 at 10:27:55PM +0100, Nikitas Angelinas wrote:
> > Replace (sizeof(ChannelRuleTab) / sizeof(ChannelRuleTab[0])) with
> > ARRAY_SIZE(ChannelRuleTab) in drivers/staging/vt6656/channel.c
> > 
> > Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
> > ---
> >  drivers/staging/vt6656/channel.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
> > index 6ad03e4..a2460ae 100644
> > --- a/drivers/staging/vt6656/channel.c
> > +++ b/drivers/staging/vt6656/channel.c
> > @@ -34,6 +34,7 @@
> >   *
> >   */
> >  
> > +#include <linux/kernel.h>
> >  #include "country.h"
> >  #include "channel.h"
> >  #include "rf.h"
> > @@ -367,7 +368,7 @@ static  struct
> >  /*                                           1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  */
> >  };
> >  
> > -#define NUM_RULES	(sizeof(ChannelRuleTab) / sizeof(ChannelRuleTab[0]))
> > +#define NUM_RULES	ARRAY_SIZE(ChannelRuleTab)
> >  
> >  /*---------------------  Export function  -------------------------*/
> >  /************************************************************************
> > -- 
> > 1.7.2.3
> > 
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
> 
> -- 
> Charles Clément
Yup, doesn't seem to be used anywhere; the file also has some coding
style issues, so perhaps removing the macro can be part of a cleanup
patch for whoever may carry out that task.

In that case, I guess reverting the patch from staging-next might be an
option, but I think what's really needed is for someone to go through
the driver source and do what's necessary... At first glance, it seems
possible that the macro (NUM_RULES) may indeed have to be used as a 
replacement for the hard-coded CB_MAX_CHANNEL, but the author may not 
have gotten around to it or didn't make use of it for some other reason.
