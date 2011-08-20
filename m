Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1HTHII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 03:08:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54137 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1HTHIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 03:08:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kBbwVLib3eUf7W79XSrh5KmKe0zXFrmi/KeP0ydus192tfJCS09rua+/jQgHxWKhb
	MUIG0NALkQlfaeKW+nZ0g==
MIME-Version: 1.0
In-Reply-To: <20110819222203.GC5146@core.coreip.homeip.net>
References: <1313666888-18939-1-git-send-email-djkurtz@chromium.org>
 <1313666888-18939-5-git-send-email-djkurtz@chromium.org> <20110819222203.GC5146@core.coreip.homeip.net>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Sat, 20 Aug 2011 15:07:41 +0800
X-Google-Sender-Auth: Vsl20B4SwaGsx5RvFanoS8SXQzA
Message-ID: <CAGS+omCZSjJoESSvimLEpj9Mwr3d9Vn78e1ZLk-NWEdgQbxNKw@mail.gmail.com>
Subject: Re: [PATCH 4/9 v4] Input: synaptics - add image sensor support
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: chase.douglas@canonical.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 6:22 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Daniel,
>
> On Thu, Aug 18, 2011 at 07:28:03PM +0800, Daniel Kurtz wrote:
>> @@ -558,6 +626,11 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>>       if (synaptics_parse_hw_state(psmouse->packet, priv, &hw))
>>               return;
>>
>> +     if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
>> +             synaptics_image_sensor_process(psmouse, &hw);
>> +             return;
>> +     }
>> +
>
> So what about the rest of the SYnaptics processing (wheel, additional
> buttons, etc)?  Are we sure that touchpads with image sensors will never
> implement them?
>
> --
> Dmitry
>

All image sensors that I am aware of are clickpads, with one button
integrated under the pad, which is reported as the middle button.

We could report right, middle, up, down, and ext_buttons (scroll is
not possible, since w=2;buf[1] is used for x for devices that send agm
packets).
However, I have no way of knowing if this added complexity is
necessary, nor any way of testing it.

-Dan
