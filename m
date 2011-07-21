Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1GUO1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:27:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33949 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1GUO1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110718123648.GA4010@shale.localdomain>
References: <1310859509.4191.6.camel@Rarity>
	<20110718123648.GA4010@shale.localdomain>
Date: Thu, 21 Jul 2011 16:27:49 +0200
Message-ID: <CAKYW3yYpzB3YbcM=Kk_zGK6q96sbRceH3XeXKp1w72WzNF8W8A@mail.gmail.com>
Subject: Re: [PATCH] Summary: Fixed all the indents and other errors in IEEE11h.c
From: Toon Schoenmakers <nighteyes1993@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, caratorn@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am really just beginning with C, so I don't think I can rewrite the
part that now is in Lisp (I didn't even know it was in Lisp until you
said so)
And with WLAN_SET_FC_FSTYPE() not being aligned I assume you mean that
you'd like to see it right under the thing that's above it, for easy
reading, right?
The aligning of it is probably the only thing I can fix at this point
of time, thanks for the suggestions though.

-Toon

On Mon, Jul 18, 2011 at 14:36, Dan Carpenter <error27@gmail.com> wrote:
> On Sun, Jul 17, 2011 at 01:38:29AM +0200, Toon Schoenmakers wrote:
>
>> +     uNumOfEIDs = ((uLength - offsetof(WLAN_FRAME_MSRREQ,
>> +                     sMSRReqEIDs))/
>> +                     (sizeof(WLAN_IE_MEASURE_REQ)));
>
> It would be better to write this in C instead of Lisp:
>
>        uNumOfEIDs = (uLength - offsetof(WLAN_FRAME_MSGREQ, sMSRReqEIDS)) /
>                        sizeof(WLAN_EI_MEASURE_REQ);
>
> The other advantage of that is that the call to offsetof() is now
> all together on one line.
>
>> +     pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
>> +sizeof(STxMgmtPacket));
>> +
>> +     pFrame = (PWLAN_FRAME_TPCREP)((unsigned char *)pTxPacket +
>> +sizeof(STxMgmtPacket));
>> +
>
> Don't do that.
>
>> +     pFrame->Header.wFrameCtl = (WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
>> +                             WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
>> +                             );
>
> The close parenthesis can fit on the end of the other line.  In fact
> the paren is not needed at all.  Why is the second line aligned where
> you have it?  The WLAN_SET_FC_FSTYPE() isn't aligned with anything.
>
> Take a another look through the patch and you'll find a bunch of
> similar issues.
>
> regards,
> dan carpenter
>
