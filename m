Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab0FWPvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:51:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64724 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab0FWPvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r+GF+4P2b1OCtnL0KYPBZq97rliu5Wx6TCchWfeVBh3Z6K7PX1Up9d8E7DcfVvxTDd
         1GM8UGN0PBA0QKexj78PDTQfkxEcmZXVHJVrUB+sROHwZWVZorToaQE/poJFbpQpSzEd
         M/Tl+z8pQfvGUyRftGO3R0BfDDqqhZso9AOMk=
MIME-Version: 1.0
In-Reply-To: <1277298125-17991-7-git-send-email-ohad@wizery.com>
References: <1277298125-17991-1-git-send-email-ohad@wizery.com>
	<1277298125-17991-7-git-send-email-ohad@wizery.com>
Date: Wed, 23 Jun 2010 18:43:31 +0300
Message-ID: <AANLkTinNSUXZkFhEhf5nRzlNGDkm_-OsOGtqfgs32717@mail.gmail.com>
Subject: Re: [PATCH 06/11] staging: ti dspbridge: add generic utilities
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Hebbar Shivananda <x0hebbar@ti.com>,
       Ramos Falcon Ernesto <ernesto@ti.com>, Anna Suman <s-anna@ti.com>,
       Kanigeri Hari <h-kanigeri2@ti.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Gupta Ramesh <grgupta@ti.com>,
       Guzman Lugo Fernando <fernando.lugo@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       Gomez Castellanos Ivan <ivan.gomez@ti.com>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Armando Uribe De Leon <x0095078@ti.com>,
       Deepak Chitriki <deepak.chitriki@ti.com>, Menon Nishanth <nm@ti.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Pitney Gilbert <gpitney@ti.com>, Bhavin Shah <bshah@ti.com>,
       Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 4:02 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Add TI's DSP Bridge generic utilities driver sources
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>


> +++ b/drivers/staging/tidspbridge/gen/uuidutil.c

Following part could be significantly simplified

> +/*
> + *  ======== htoi ========
> + *  Purpose:
> + *      Converts a hex value to a decimal integer.
> + */

> +/*
> + *  ======== uuid_uuid_from_string ========
> + *  Purpose:
> + *      Converts a string to a struct dsp_uuid.
> + */


There is a code (because I am already in s-o-b list I just put here
the excerpts, however, I could prepare patch in standard form, if you
want to)

static s32 uuid_hex_to_bin(char *buf, s32 len)
{
        s32 i;
        s32 result = 0;

        for (i = 0; i < len; i++) {
                value = hex_to_bin(*buf++);
                result *= 16;
                if (value > 0)
                        result += value;
        }

        return result;
}

void uuid_uuid_from_string(IN char *pszUuid, OUT struct dsp_uuid *uuid_obj)
{
        s32 j;

        uuid_obj->ul_data1 = uuid_hex_to_bin(pszUuid, 8);
        pszUuid += 8;

        /* Step over underscore */
        pszUuid++;

        uuid_obj->us_data2 = (u16) uuid_hex_to_bin(pszUuid, 4);
        pszUuid += 4;

        /* Step over underscore */
        pszUuid++;

        uuid_obj->us_data3 = (u16) uuid_hex_to_bin(pszUuid, 4);
        pszUuid += 4;

        /* Step over underscore */
        pszUuid++;

        uuid_obj->uc_data4 = (u8) uuid_hex_to_bin(pszUuid, 2);
        pszUuid += 2;

        uuid_obj->uc_data5 = (u8) uuid_hex_to_bin(pszUuid, 2);
        pszUuid += 2;

        /* Step over underscore */
        pszUuid++;

        for (j = 0; j < 6; j++) {
                uuid_obj->uc_data6[j] = (u8) uuid_hex_to_bin(pszUuid, 2);
                pszUuid += 2;
        }
}



-- 
With Best Regards,
Andy Shevchenko
