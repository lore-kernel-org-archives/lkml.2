Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1CUT5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:57:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40933 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1CUT5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nQ3jzihfy/0Nw7w2HOuPCXJe07cjnAoG0uciQgABB7SI96pYnfxNLxKlkT/FbaSOx4
         BtvI9lat3DvHZ50aLbIu1GMOFhmTrHuLsuakXCPZwNX+IusnM1lIjXK8i4isQXUPXO17
         1+g/mB+53ca87xWxscF9idB9vTgYlmpG7sNmc=
MIME-Version: 1.0
In-Reply-To: <20110321190606.GA1792@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
	<1300454876-5017-6-git-send-email-benjamin.tissoires@enac.fr>
	<20110321090533.GE3784@polaris.bitmath.org>
	<AANLkTinAPFnHA=MWbb=Yu7U0AXrxHv2-95M=OequsAL7@mail.gmail.com>
	<20110321190606.GA1792@polaris.bitmath.org>
Date: Mon, 21 Mar 2011 20:56:59 +0100
X-Google-Sender-Auth: ouJtbRWEb-xiZVlhlYMs1qXV-N8
Message-ID: <AANLkTimFF3pgMMgOcEhYnRm5adgsCL5S6Hjkz+GFcpCT@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] hid-multitouch: migrate 3M PCT touch screens to hid-multitouch
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

thanks a lot for spotting this.
I think the modification is safe, but I'll give a final test tomorrow
against our hardware.

Thanks,
Benjamin

On Mon, Mar 21, 2011 at 20:06, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> I tested it against 3M1968. I'll try to have it again to make more testing.
>> What symptoms do you have?
>
> With the modification below, it works as expected, and you can add
>
>    Reviewed-and-tested-by: Henrik Rydberg <rydberg@euromail.se>
>
> Thanks!
>
> Henrik
>
> ---
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 7684e96..0f5b89f 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -424,6 +424,8 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>                        break;
>
>                default:
> +                       if (td->last_field_index && field->index == td->last_field_index)
> +                               break;
>                        /* fallback to the generic hidinput handling */
>                        return 0;
>                }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
