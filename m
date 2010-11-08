Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0KHMTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:19:21 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51298 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0KHMTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:19:20 -0500
From: <ilkka.koskinen@nokia.com>
To: <alan@lxorguk.ukuu.org.uk>
CC: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Date: Mon, 8 Nov 2010 13:18:49 +0100
Subject: RE: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Topic: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Index: Act/OcViEgdH9OBsS2yLohCMGUu1dAAA7Ucg
Message-ID: <F80267346F10C541946CBE8909F1C39E36817A88F7@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
	<20101107235157.728ea5b6@lxorguk.ukuu.org.uk>
	<F80267346F10C541946CBE8909F1C39E36817A8845@NOK-EUMSG-02.mgdnok.nokia.com>
 <20101108113853.772b960e@lxorguk.ukuu.org.uk>
In-Reply-To: <20101108113853.772b960e@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Nov 2010 12:18:51.0488 (UTC) FILETIME=[1A867E00:01CB7F3F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: ext Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: 08 November, 2010 13:39
>
>On Mon, 8 Nov 2010 12:08:07 +0100
><ilkka.koskinen@nokia.com> wrote:
>
>> Hi,
>>
>> >From: ext Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>> >Sent: 08 November, 2010 01:52
>> >
>> >> +	datalen = p->custom_len * sizeof(p->custom_data[0]);
>> >
>> >signed
>> >
>> >> +	if (datalen > MAX_EFFECT_SIZE) {
>> >
>> >unsigned
>>
>> It should be unsigned. I'll fix it.
>>
>> >> +	memcpy(einfo->buf, p->custom_data, datalen);
>> >
>> >ungood
>>
>> Yep, that's clearly wrong too. Should be copy_from_user() I suppose.
>
>That I hadn't considered - and I'm not sure whether the caller is passed
>a kernel copy or not. The problem I was looking at was just the signed
>case
>
>	datalen < 0
>	if (datalen > MAX ..)
>		Nope
>
>	memcpy(kernel, mysource, vastly more than intended (unsigned))

Ah, I got it now. Thanks for clarification :) 

Cheers, Ilkka

