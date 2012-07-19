Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab2GSQVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:21:02 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:31982 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2GSQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:21:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1342714788!10062308!98
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Thu, 19 Jul 2012 11:20:52 -0500
Subject: RE: [PATCH 01/90] staging: comedi: comedidev.h: introduce
 comedi_to_pci_dev() helper
Thread-Topic: [PATCH 01/90] staging: comedi: comedidev.h: introduce
 comedi_to_pci_dev() helper
Thread-Index: Ac1lkA8XCD8BCoNbRoetUX8SiY6J0gAOMeUw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA91644B@AUSP01VMBX24.collaborationhost.net>
References: <201207181824.15722.hartleys@visionengravers.com>
 <5007D1E0.4050503@mev.co.uk>
In-Reply-To: <5007D1E0.4050503@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6JGL5om018728

On Thursday, July 19, 2012 2:23 AM, Ian Abbott wrote:
> On 2012-07-19 02:24, H Hartley Sweeten wrote:
>> Introduce a wrapper for to_pci_dev() to allow the comedi pci drivers
>> to store the pci_dev pointer in the comedi_device hw_dev variable and
>> retrieve it easily.
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   drivers/staging/comedi/comedidev.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
>> index de8c99c..620222d 100644
>> --- a/drivers/staging/comedi/comedidev.h
>> +++ b/drivers/staging/comedi/comedidev.h
>> @@ -446,6 +446,11 @@ static inline void comedi_set_hw_dev(struct comedi_device *dev,
>>   	}
>>   }
>>
>> +static inline struct pci_dev *comedi_to_pci_dev(struct comedi_device *dev)
>> +{
>> +	return to_pci_dev(dev->hw_dev);
>> +}
>> +
>
> That needs to be something like:
>
>	return dev->hw_dev ? to_pci_dev(dev->hw_dev) : NULL;

Hmm.. I'm not really sure.

I assumed that the container_of() macro would return NULL if the ptr passed to
it was NULL. But, I'm not sure how this actually unwinds for that case.

Greg, do you know if the NULL check is needed? It's is possible that the dev->hw_dev
pointer could be NULL.

Thanks,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
