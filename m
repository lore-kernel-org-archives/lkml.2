Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2LEJ5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:57:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab2LEJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:56:56 -0500
Date: Wed, 5 Dec 2012 10:56:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] HID: i2c-hid: fix i2c_hid_dbg macro
In-Reply-To: <20121204224950.6ebd7346@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212051056460.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-6-git-send-email-benjamin.tissoires@gmail.com> <20121204224950.6ebd7346@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012, Jean Delvare wrote:

> > This avoids the problematic case:
> > 
> > if (condition)
> > 	i2c_hid_dbg(ihid, "Blah blah %d\n", i);
> > else
> > 	do_something_very_important();
> > 
> > Which looks correct, however with the previous macro definition,
> > this expands to the unexpected:
> > 
> > if (condition) {
> > 	if (debug)	\
> > 		dev_printk(KERN_DEBUG, &ihid->client->dev,
> > 				"Blah blah %d\n", i);
> > 	else
> > 		do_something_very_important();
> > }
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index 9ee6555..54950be 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -50,9 +50,11 @@ static bool debug;
> >  module_param(debug, bool, 0444);
> >  MODULE_PARM_DESC(debug, "print a lot of debug information");
> >  
> > -#define i2c_hid_dbg(ihid, fmt, arg...)	\
> > -	if (debug)			\
> > -		dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg)
> > +#define i2c_hid_dbg(ihid, fmt, arg...)					  \
> > +do {									  \
> > +	if (debug)							  \
> > +		dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg); \
> > +} while (0)
> >  
> >  struct i2c_hid_desc {
> >  	__le16 wHIDDescLength;
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

Applied.

-- 
Jiri Kosina
SUSE Labs
