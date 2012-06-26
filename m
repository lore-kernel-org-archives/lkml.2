Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab2FZRLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:11:05 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:17607 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab2FZRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:11:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1340730647!6952721!13
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>, Ian Abbott <ian.abbott@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Tue, 26 Jun 2012 12:10:54 -0500
Subject: RE: [PATCH 28/33] staging: comedi: cb_das16_cs: cleanup
 das16cs_ai_rinsn()
Thread-Topic: [PATCH 28/33] staging: comedi: cb_das16_cs: cleanup
 das16cs_ai_rinsn()
Thread-Index: Ac1TfD7mkU8sWPaOSK+ZVrpN39WHkQAQi+Kg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698F2E3D9@AUSP01VMBX24.collaborationhost.net>
References: <201206251717.53025.hartleys@visionengravers.com>
 <4FE97C3E.40508@mev.co.uk> <4FE97DB2.9070101@mev.co.uk>
In-Reply-To: <4FE97DB2.9070101@mev.co.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5QHBA0r006766

On Tuesday, June 26, 2012 2:16 AM, Ian Abbott wrote:
> On 2012-06-26 10:09, Ian Abbott wrote:
>> On 2012-06-26 01:17, H Hartley Sweeten wrote:
>>> @@ -129,7 +124,22 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
>>>    	outw(devpriv->status1, dev->iobase + 4);
>>>
>>>    	devpriv->status2 &= ~0xff00;
>>> -	devpriv->status2 |= range_bits[range];
>>> +	switch (range) {
>>> +	case 0:
>>> +		devpriv->status2 |= 0x800;
>>> +		break;
>>> +	case 1:
>>> +		devpriv->status2 |= 0x000;
>>> +		break;
>>> +	case 2:
>>> +		devpriv->status2 |= 0x100;
>>> +		break;
>>> +	case 3:
>>> +		devpriv->status2 |= 0x200;
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>
>> Is that really an improvement?  The 'range' variable value will be in
>> range anyway (the comedi core checks beforehand in
>> comedi_check_chanlist()), and looking up the constant to OR with
>> devpriv->status2 is probably less object code (and certainly less source
>> code).
>
> I meant looking up the constant in the static array of course.  It 
> doesn't really matter if you want to do it this way though, and the 
> `static int range_bits[]` you removed should have been `static const int 
> range_bits[]` anyway.

This, and your other comment about the PCMCIA support, have
been addressed.

Thanks for the review!

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
