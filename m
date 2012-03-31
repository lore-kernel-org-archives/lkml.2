Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab2CaOJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:09:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54098 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab2CaOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:09:32 -0400
Date: Sat, 31 Mar 2012 16:09:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 05/15] hwmon: mark const init data with __initconst
 instead of __initdata
Message-ID: <20120331140924.GW15647@pengutronix.de>
References: <20120330200358.GV15647@pengutronix.de>
 <1333137905-13809-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <20120331035442.GA23851@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120331035442.GA23851@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guenter,

On Fri, Mar 30, 2012 at 08:54:42PM -0700, Guenter Roeck wrote:
> On Fri, Mar 30, 2012 at 04:04:55PM -0400, Uwe Kleine-König wrote:
> > As long as there is no other non-const variable marked __initdata in the
> > same compilation unit it doesn't hurt. If there were one however
> > compilation would fail with
> > 
> > 	error: $variablename causes a section type conflict
> > 
> > because a section containing const variables is marked read only and so
> > cannot contain non-const variables.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> > Cc: lm-sensors@lm-sensors.org
> > ---
> > changes since (implicit) v1:
> >  - drop wrong changes to drivers/hwmon/w83627hf.c
> > 
> >  drivers/hwmon/w83627ehf.c |   18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
> > index a25350c..54922ed 100644
> > --- a/drivers/hwmon/w83627ehf.c
> > +++ b/drivers/hwmon/w83627ehf.c
> > @@ -2619,15 +2619,15 @@ static struct platform_driver w83627ehf_driver = {
> >  static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
> >  				 struct w83627ehf_sio_data *sio_data)
> >  {
> > -	static const char __initdata sio_name_W83627EHF[] = "W83627EHF";
> > -	static const char __initdata sio_name_W83627EHG[] = "W83627EHG";
> > -	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
> > -	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
> > -	static const char __initdata sio_name_W83627UHG[] = "W83627UHG";
> > -	static const char __initdata sio_name_W83667HG[] = "W83667HG";
> > -	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
> > -	static const char __initdata sio_name_NCT6775[] = "NCT6775F";
> > -	static const char __initdata sio_name_NCT6776[] = "NCT6776F";
> > +	static const char sio_name_W83627EHF[] __initconst = "W83627EHF";
> > +	static const char sio_name_W83627EHG[] __initconst = "W83627EHG";
> > +	static const char sio_name_W83627DHG[] __initconst = "W83627DHG";
> > +	static const char sio_name_W83627DHG_P[] __initconst = "W83627DHG-P";
> > +	static const char sio_name_W83627UHG[] __initconst = "W83627UHG";
> > +	static const char sio_name_W83667HG[] __initconst = "W83667HG";
> > +	static const char sio_name_W83667HG_B[] __initconst = "W83667HG-B";
> > +	static const char sio_name_NCT6775[] __initconst = "NCT6775F";
> > +	static const char sio_name_NCT6776[] __initconst = "NCT6776F";
> >  
> Applied.
> 
> Just wondering: Why not the following ?
> 
> > +	static const char __initconst sio_name_NCT6776[] = "NCT6776F";
> 
> It does not make a difference in the generated code, and appears to be
> less confusing, at least to me.
hmm, I thought it does, maybe it's compiler dependant?! At least
gcc-4.4.info tells:

	An attribute specifier list may appear immediately before the
	comma, `=' or semicolon terminating the declaration of an
	identifier other than a function definition.

and include/linux/init.h has:

	You should insert __initdata between the variable name and equal
	sign followed by value [...].

I seem to remember that placing the attribute at the wrong place for a
function made gcc ignore it (or apply it so something unintended).

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
