Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1GEEkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:40:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1GEEkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:40:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=sJaduZ4ZhKBLymtdA5hJONj7YvLTL99gZSdygtmFBm2pVrY6EAyf8JQdAjiom5hHa
	R4wMA83elBGaUd4dFccKg==
MIME-Version: 1.0
In-Reply-To: <20110704212640.GD23915@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-8-git-send-email-djkurtz@chromium.org> <20110704212640.GD23915@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 5 Jul 2011 12:39:58 +0800
X-Google-Sender-Auth: eOMDKNpwIaKBRmhLKuPKUTOQ3Bo
Message-ID: <CAGS+omCGt_oqkuWPdAtXfuWMvWAD5kL9oxRLmKroRSfLAk8VGg@mail.gmail.com>
Subject: Re: [PATCH 07/12] Input: synaptics - rename synaptics_data.mt to agm
To: Henrik Rydberg <rydberg@euromail.se>
Cc: dmitry.torokhov@gmail.com, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 5:26 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Jun 29, 2011 at 01:07:17PM +0800, djkurtz@chromium.org wrote:
>> From: Daniel Kurtz <djkurtz@chromium.org>
>>
>> Rename the synaptics_data.mt field to priv->agm to indicate it is the
>> hardware state reported in a synaptics AGM packet.
>>
>> When a Synaptics touchpad is in "AGM" mode, and multiple fingers are
>> detected, the touchpad sends alternating "Advanced Gesture Mode" (AGM) and
>> "Simple Gesture Mode" (SGM) packets.
>>   The AGM packets have w=2, and contain reduced resolution finger data.
>>   The SGM packets have w={0,1} and contain full resolution finger data.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>
> How about just modifying the comment, i.e., leaving this hunk?

IMHO, changing the field name from mt to agm makes the following
patches more clear, by making it easier to see the difference between
sgm and agm packets.

>
>> @@ -147,7 +147,7 @@ struct synaptics_data {
>>
>>       struct serio *pt_port;                  /* Pass-through serio port */
>>
>> -     struct synaptics_hw_state mt;           /* current gesture packet */
>> +     struct synaptics_hw_state agm;          /* last AGM packet */
>>  };
>>
>>  void synaptics_module_init(void);
>> --
>
> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
