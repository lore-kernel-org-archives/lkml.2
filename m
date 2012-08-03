Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2HCPa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:30:27 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:24473 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2HCPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:30:25 -0400
Message-ID: <501BEEA8.4060702@laposte.net>
Date: Fri, 03 Aug 2012 17:30:48 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v2 3/3] input: misc: New USB eBeam input driver.
References: <1343912397-18353-1-git-send-email-yann.cantin@laposte.net> <1343912397-18353-4-git-send-email-yann.cantin@laposte.net> <alpine.LRH.2.00.1208031424250.15211@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1208031424250.15211@twin.jikos.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> +#include <linux/hid.h>
> 
> As this driver is not a HID bus driver, why do you need this include?

Cinder, removed

>> +#define DRIVER_VERSION	"v0.7"
> 
> I don't think we need to be tracking driver versions for newly submitted 
> drivers, git is much better at tracking changes.

Old habit, removed.

>> +	u16			 X, Y;		/* raw coordinates	     */
>> +	int			 x, y;		/* computed coordinates      */
> 
> X,x being different fields seems confusing to me. How about, let's say, x, 
> raw_x?

Done.
 
>> +DEVICE_H_ATTR(1);
>> +DEVICE_H_ATTR(2);
>> +DEVICE_H_ATTR(3);
>> +DEVICE_H_ATTR(4);
>> +DEVICE_H_ATTR(5);
>> +DEVICE_H_ATTR(6);
>> +DEVICE_H_ATTR(7);
>> +DEVICE_H_ATTR(8);
>> +DEVICE_H_ATTR(9);
> 
> You are adding a number of sysfs files. If they are really necessary, 
> you'll probably need to document those in Documentation/ABI.

Will do, in testing i suppose.

BTW : The driver need lot of parameters to be passed from user-space calibration
tool. The best way to do it isn't decided yet : one sysfs file per parameter, or
one sysfs file for all, with a big sscanf parsing. Any idea ?

>> +		strlcat(ebeam->name, ")", sizeof(ebeam->name));
> 
> I'd suggest checking the length, making sure that you don't overflow the 
> ->name buffer.

Something like this ? :

if (strlcat(ebeam->name, ")", sizeof(ebeam->name))>=sizeof(ebeam->name)) {
	// overflowed, closing ) anyway
	ebeam->name[sizeof(ebeam->name)-2] = ')';

Thanks.
-- 
Yann Cantin
A4FEB47F
--
