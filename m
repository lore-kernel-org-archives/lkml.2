Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1EDHNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:13:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42836 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1EDHNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:13:13 -0400
Message-ID: <15AD189F851849F69A011B6F4D1DDB6C@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <Netdev@vger.kernel.org>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        <m-watkins@ti.com>
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <4DB5D452.9050500@grandegger.com> <46D523E49EFF489F9B088AE7B9CD7286@subhasishg> <201104271525.28512.arnd@arndb.de>
In-Reply-To: <201104271525.28512.arnd@arndb.de>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Wed, 4 May 2011 12:43:08 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 27 April 2011, Subhasish Ghosh wrote:
>> >
>> > - Use just one value per sysfs file
>> 
>> SG - I felt adding entry for each mbx_id will clutter the sysfs.
>>         Is it ok to do that.
> 
> That is probably not much better either.
> 
> Note also that every sysfs file needs to come with associated
> documentation in Documentation/ABI/*/ to make sure that users
> will know exactly how the file is meant to work. 
> 
> Why do you need to export these values in the first place? Is
> it just for debugging or do you expect all CAN user space
> to look at this?
> 
> If it's for debugging, please don't export the files through sysfs.
> Depending on how useful the data is to regular users, you can
> still export it through a debugfs file in that case, which has
> much less strict rules.
> 
> If the file is instead meant as part of the regular operation of
> the device, it should not be in debugfs but probably be integrated
> into the CAN socket interface, so that users don't need to work
> with two different ways of getting to the device (socket and sysfs).
> 

CAN requires mail box IDs to be programmed in. But, the socket
CAN subsystem supports only software filtering of the mail box IDs.

So, the mail box IDs programmed into socket CAN during initialization
does not propagate into the hardware. This is planned to be a future
implementation in Socket CAN.

In our case, we support hardware filtering, to work around with this,
Wolfgang (Socket CAN owner) suggested that we implement
this using sysfs.

These setting are not for debugging, but to program the mail box IDs
into the hardware. 
