Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2LEKNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:13:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab2LEKNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:13:52 -0500
Date: Wed, 5 Dec 2012 11:13:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] HID: i2c-hid: fix memory corruption due to missing
 hid declaration
In-Reply-To: <CAN+gG=Hk+BCexxUif2Eqt9sQ4-_K1dfiUx5xD52-Hj2k5hUPug@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1212051112520.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-3-git-send-email-benjamin.tissoires@gmail.com> <20121204224205.58420e3f@endymion.delvare> <CAN+gG=Hk+BCexxUif2Eqt9sQ4-_K1dfiUx5xD52-Hj2k5hUPug@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012, Benjamin Tissoires wrote:

> > On Tue,  4 Dec 2012 16:27:43 +0100, Benjamin Tissoires wrote:
> >> HID descriptors contains 4 bytes of reserved field.
> >> The previous implementation was overriding the next fields in struct i2c_hid.
> >>
> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> >> ---
> >>  drivers/hid/i2c-hid/i2c-hid.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> >> index 0fbb229..ad771a7 100644
> >> --- a/drivers/hid/i2c-hid/i2c-hid.c
> >> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> >> @@ -68,6 +68,7 @@ struct i2c_hid_desc {
> >>       __le16 wVendorID;
> >>       __le16 wProductID;
> >>       __le16 wVersionID;
> >> +     __le32 reserved;
> >>  } __packed;
> >>
> >>  struct i2c_hid_cmd {
> >> @@ -778,7 +779,7 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
> >>       }
> >>
> >>       dsize = le16_to_cpu(hdesc->wHIDDescLength);
> >> -     if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
> >> +     if (!dsize || dsize > sizeof(struct i2c_hid_desc)) {
> >
> > Shouldn't !dsize rather be dsize < 4? You're reading hdesc->bcdVersion,
> > which is only defined if dsize >= 4 if I understand the code correctly.
> 
> Yes, you are right. Thanks.
> 
> Jiri, this patch is a prerequisite for "[PATCH 10/14] HID: i2c-hid:
> reorder allocation/free of buffers".
> could you please what for a v2 before applying 10/14?

Absolutely. I still have to review 9, 10, 11, 12, 13, 14, so am dropping 2 
and 10 from my attention for now.

-- 
Jiri Kosina
SUSE Labs
