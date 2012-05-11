Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab2EKS0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:26:42 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:46543 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2EKS0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:26:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1336760799!5240183!3
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Fri, 11 May 2012 13:26:37 -0500
Subject: RE: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
Thread-Topic: [PATCH] staging: comedi: Add helper macro for comedi pci
 driver boilerplate
Thread-Index: Ac0voeus9KUNZGk3Sa+hFNQboVCcQAAAJX5g
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17ECA@AUSP01VMBX24.collaborationhost.net>
References: <201205111007.46754.hartleys@visionengravers.com>
 <4FAD4D20.1010302@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698A17E6A@AUSP01VMBX24.collaborationhost.net>
 <4FAD4F7F.1060603@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698A17E89@AUSP01VMBX24.collaborationhost.net>
 <4FAD5703.7080504@mev.co.uk>
In-Reply-To: <4FAD5703.7080504@mev.co.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4BIQmHG021052

On Friday, May 11, 2012 11:14 AM, Ian Abbott wrote:
> Okay, but I don't think it's worth doing three patches for each driver 
> where one would do.  Adding a one-line .name = "foo", to the single 
> patch for each driver you were planning to do anyway seems like a 
> trivial addition that could be slotted into the patch without too much 
> argument from the "one change per patch" folks, especially if you 
> mention the purpose of that line in the commit message.  (I'd defer to 
> the better judgement of Greg though.)

With this patch my main goal was to not "break" any of the drivers.

As a follow-up to this patch I was going to use the macro in all the
pci drivers that have been refactored. Similar to what I did with the
module_comedi_driver macro. When I do that I can add the static
name field to those drivers.

How about doing this in the register function:

	If (!pci_driver->name)
		pci_driver->name = comedi_driver->driver_name;

This way all the drivers that still need to be refactored will still work.

After all the drivers have been updated, those two lines can be
removed.

So we have this patch and one big patch updating all the refactored
drivers. Some number of patches refactoring the remaining drivers
and using the module_comedi_pci_driver macro. Then one last
patch removing the check above.

How does that sound?

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
