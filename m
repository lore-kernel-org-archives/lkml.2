Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2LEKbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:31:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2LEKbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:31:01 -0500
Date: Wed, 5 Dec 2012 11:30:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] HID: i2c-hid: remove unneeded test in
 i2c_hid_remove
In-Reply-To: <20121205111352.4d7e7876@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212051130240.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-12-git-send-email-benjamin.tissoires@gmail.com> <20121205111352.4d7e7876@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012, Jean Delvare wrote:

> > ihid can not be null, so there are no reasons to test it.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index 4e3f80b..2b49929 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -890,9 +890,6 @@ static int __devexit i2c_hid_remove(struct i2c_client *client)
> >  	struct i2c_hid *ihid = i2c_get_clientdata(client);
> >  	struct hid_device *hid;
> >  
> > -	if (WARN_ON(!ihid))
> > -		return -1;
> > -
> >  	hid = ihid->hid;
> >  	hid_destroy_device(hid);
> >  
> 
> This leaves <linux/bug.h> included for no good reason. Please remove it
> too.

I have applied the patch, and removed the superfluous include as well, 
thanks for spotting that, Jean.

-- 
Jiri Kosina
SUSE Labs
