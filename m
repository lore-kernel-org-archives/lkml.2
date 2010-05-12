Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0ELR5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:57:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52286 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0ELR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QBMAAB7ZoFBx4RHPZEatccApGre0FvjxyV3YVEJapsxvVhg4+sdDVLGMIsbqpTRjB8
         cVodfSB+1CPVdQQ/gUyrak20v0TTlDSVpp/r99oUnLmhStN/6DQ5hLSSxpC+QtPzqsGD
         QtlUclbK0YYqBVDMPtJtZOlH0q62rf3v6T8yc=
Date: Wed, 12 May 2010 10:51:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100512175121.GC16431@core.coreip.homeip.net>
References: <1273623083.2314.4.camel@localhost.localdomain>
 <AANLkTimUrjqc3cVt7pDcPZ_-GSalU4mCL5TfetdT-Sel@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimUrjqc3cVt7pDcPZ_-GSalU4mCL5TfetdT-Sel@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 01:51:13PM +0300, Felipe Contreras wrote:
> On Wed, May 12, 2010 at 3:11 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > As those computers never had any i8042 controllers, and the
> > current lookup code could potentially lock up/hang/wait for
> > timeout for long periods of time.
> >
> > Fixes intermittent hangs on boot on a MacbookAir1,1
> >
> > Signed-off-by: Bastien Nocera <hadess@hadess.net>
> > ---
> >  drivers/input/serio/i8042-x86ia64io.h |   18 ++++++++++++++++++
> >  1 files changed, 18 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> > index ead0494..e859902 100644
> > --- a/drivers/input/serio/i8042-x86ia64io.h
> > +++ b/drivers/input/serio/i8042-x86ia64io.h
> > @@ -479,6 +479,22 @@ static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
> >        { }
> >  };
> >
> > +/* Intel Apple Macs never have an i8042 controller,
> > + * so we shouldn't even try to probe for it */
> > +static const struct dmi_system_id __initconst i8042_dmi_no_probe_table[] = {
> > +       {
> > +               .matches = {
> > +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Computer, Inc.")
> > +               },
> > +       },
> > +       {
> > +               .matches = {
> > +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Inc.")
> > +               },
> > +       },
> > +       {}
> 
> No need for that extra {}
> 

Actually, there is.

-- 
Dmitry
