Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2GSROl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:14:41 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:63374 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:14:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1342718015!9080771!42
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Thu, 19 Jul 2012 12:14:30 -0500
Subject: RE: [PATCH 30/90] staging: comedi: amplc_dio200: store the pci_dev
 in the comedi_device
Thread-Topic: [PATCH 30/90] staging: comedi: amplc_dio200: store the pci_dev
 in the comedi_device
Thread-Index: Ac1llsK7UGQRJu6pQMyQ/VfAqSehfAAOwB4Q
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA916474@AUSP01VMBX24.collaborationhost.net>
References: <201207181837.50650.hartleys@visionengravers.com>
 <5007DD1F.4040703@mev.co.uk>
In-Reply-To: <5007DD1F.4040703@mev.co.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6JHElpq019029

On Thursday, July 19, 2012 3:11 AM, Ian Abbott wrote:
> On 2012-07-19 02:37, H Hartley Sweeten wrote:
>> Use the hw_dev pointer in the comedi_device struct to hold the
>> pci_dev instead of carrying it in the private data.
>>
>> Since the pci_dev is no longer held in the provate data, we can
>> also cleanup the detach a bit. Remove the IS_ENABLED() tests in
>> the detach. If the pci_dev is non NULL it's a PCI device otherwise
>> it's an ISA device. Using IS_ENABLED() to omit the code paths
>> makes the code a bit confusing and doesn't save much.
>
> No, you really need to check thisboard->bustype in the detach() because 
> hw_dev might be NULL for a PCI board if the attach() failed.

Ah, overlooked that.

I still think the IS_ENABLED() stuff should be removed where possible. It
just looks confusing in the if().

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
