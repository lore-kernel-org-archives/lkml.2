Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095Ab0JZQwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:52:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26207 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab0JZQwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:52:43 -0400
From: <ilkka.koskinen@nokia.com>
To: <alan@lxorguk.ukuu.org.uk>, <grant.likely@secretlab.ca>
CC: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <ilkka.koskinen@nokia.com>
Date: Tue, 26 Oct 2010 18:52:07 +0200
Subject: RE: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Topic: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Thread-Index: Act0/5qQKnIz+ZSESiGQdf9DdVQmrgALlGSQ
Message-ID: <F80267346F10C541946CBE8909F1C39E35932598BD@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
	<20101026111344.GB24714@angua.secretlab.ca>
 <20101026121749.298dc60a@lxorguk.ukuu.org.uk>
In-Reply-To: <20101026121749.298dc60a@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Oct 2010 16:52:09.0814 (UTC) FILETIME=[2151B760:01CB752E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From: ext Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: 26 October, 2010 14:18
>To: Grant Likely
>Cc: Koskinen Ilkka (Nokia-MS/Tampere); linux-input@vger.kernel.org;
>dmitry.torokhov@gmail.com; spi-devel-general@lists.sourceforge.net;
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] input: spi: Driver for SPI data stream driven
>vibrator
>
>> > +	if (!einfo->buf) {
>> > +		einfo->buf = kzalloc(datalen, GFP_KERNEL | GFP_DMA);
>> > +		if (!einfo->buf) {
>> > +			ret = -ENOMEM;
>> > +			goto exit;
>> > +		}
>> > +	}
>> > +
>> > +	memcpy(einfo->buf, p->custom_data, datalen);
>>
>> It looks like raw data from userspace is being passed on to the
>> device.  Is this sane?  Is there already a data format used by other
>> vibration/feedback devices that should be used here instead and
>> translated into the form expected by the hardware?
>
>It also seems to be using GFP_DMA not dma_alloc functions which looks a
>bit odd and certainly isn't portable.

Right, I'll change it to the appropriate ones.

Cheers, Ilkka
