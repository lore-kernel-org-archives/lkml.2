Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab1FPHoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:44:11 -0400
Received: from fep12.mx.upcmail.net ([62.179.121.32]:42974 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1FPHoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:44:06 -0400
X-SourceIP: 178.83.226.131
Message-ID: <4DF9B440.9070500@odi.ch>
Date: Thu, 16 Jun 2011 09:44:00 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39.1 input regression
References: <4DF85C5F.4080307@odi.ch> <20110615150326.GA7128@suse.de>
In-Reply-To: <20110615150326.GA7128@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=tMVj8KYobzzX0EiRnC7vY2isLrCxFvdg4RrHWPZXwJ0= c=1 sm=0 a=GuWncwZLQJwA:10 a=eIhxMilvRf8A:10 a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8 a=m3MDCCSdBgwMK93jqCYA:9 a=wPNLvfGTeEIA:10 a=LI9Vle30uBYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 15.06.2011 17:03, Greg KH wrote:
> On Wed, Jun 15, 2011 at 09:16:47AM +0200, Ortwin Glück wrote:
>> Hi Greg,
>>
>> This patch in 2.6.39.1 breaks magicmouse support for me completely.
>> a5ccaac64c17ce3cc1878a6d479a6f1b16092c24
>> HID: magicmouse: ignore 'ivalid report id' while switching modes
>>
>> The device will no longer work at all:
>> magicmouse 0005:05AC:030D.0005: input,hidraw2: BLUETOOTH HID v0.84 Mouse
>> [gandalf mouse] on 7C:6D:62:9F:DB:2D
>> magicmouse 0005:05AC:030D.0005: unable to request touch data (2)
>>
>> Fine in previous kernels.
> 
> This has been discussed already, and it should be fixed in Linus's tree
> right now, right?
> 
> If so, can someone please send stable@kernel.org the proper fix for
> this?
> 
> thanks,
> 
> greg k-h

If it's in Linus' tree then I can't find it. To me this issue just looks
like a silly typo anyway:

-	if (ret != sizeof(feature)) {
+	if (ret != -EIO) {
 		hid_err(hdev, "unable to request touch data (%d)\n", ret);
 		goto err_stop_hw;
 	}

Should this not be (ret == -EIO)?

Ortwin
