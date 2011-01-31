Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1AaVeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:34:17 -0500
Received: from www17.your-server.de ([213.133.104.17]:43666 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1AaVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:34:16 -0500
References: <1295693349.2120.3.camel@localhost.localdomain> <201101222043.07703.rjw@sisk.pl> <1296249125.2006.7.camel@localhost.localdomain> <201101312139.03634.rjw@sisk.pl>
In-Reply-To: <201101312139.03634.rjw@sisk.pl>
Mime-Version: 1.0 (iPod Mail 8C148)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <DB7A733A-D21A-4134-B50F-121CE2C179D3@m3y3r.de>
Cc: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
X-Mailer: iPod Mail (8C148)
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.38-rc2: acpi backlight control missing
Date: Mon, 31 Jan 2011 22:34:16 +0100
To: "Rafael J. Wysocki" <rjw@sisk.pl>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.01.2011 um 21:39 schrieb "Rafael J. Wysocki" <rjw@sisk.pl>:

> On Friday, January 28, 2011, Thomas Meyer wrote:
>> Am Samstag, den 22.01.2011, 20:43 +0100 schrieb Rafael J. Wysocki:
>>> On Saturday, January 22, 2011, Thomas Meyer wrote:
>>>> with 2.6.38-rc2 the acpi backlight is gone:
>>>> 
>>>> any ideas?
>>> 
>>> Not really, but Matthew may have some (CCed).
>> 
>> Okay, found the problem.
>> 
>> This commit broke my backlight:
>> 
>> commit 677bd810eedce61edf15452491781ff046b92edc
>> Author: Zhang Rui <rui.zhang@intel.com>
>> Date:   Mon Dec 6 15:04:21 2010 +0800
>> 
>>    ACPI video: remove output switching control
>> 
>> This is because in function
>> "acpi_is_video_device()" (drivers/acpi/video_detect.c) the backlight
>> device is only checked when some video capabilities were found, but by
>> removing the check for the VIDEO_OUTPUT_SWITCHING (that seems to be the
>> only video capability on my system) the check for the backlight device
>> isn't done anymore.
>> 
>> by reverting above commit, the backlight is back again.
> 
> Is it the same issue as https://bugzilla.kernel.org/show_bug.cgi?id=27702 ?

Yes, it is.

> In case it is, can you test the patch in there, please?
> 

Didn't test the patch. But it should do the trick.

> Rafael
