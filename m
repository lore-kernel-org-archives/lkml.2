Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2AUOz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 09:55:28 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:44166 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2AUOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:55:24 -0500
Message-ID: <4F1AD195.70305@freemail.hu>
Date: Sat, 21 Jan 2012 15:54:13 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        devel@driverdev.osuosl.org, techeng <dzshen@gmail.com>, clyu@citiz.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add Winbond WB528SD Secure Digital (SD) card reader driver
References: <4F1A98F5.3080402@freemail.hu> <20120121125153.GB18829@suse.de>
In-Reply-To: <20120121125153.GB18829@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 188.143.83.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

thanks for your response and your questions, I think it will help my
work very much.

Greg KH wrote:
> On Sat, Jan 21, 2012 at 11:52:37AM +0100, Németh Márton wrote:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> This driver version of Winbond WB528SD can detect mechanical card
>> presence only. The information is provided through sysfs.
> 
> How is it provided through sysfs?  Is this done in a standard way?  If
> not, why not?

I used device_create_file()/device_remove_file() and DEVICE_ATTR(), in
that sense it is standard. I'm not sure, however, that you a referring
to this, rather referring to the standard way how other SD card readers
provide the card presence information to the user space, right?
To tell you the truth, I could not find an other PCI card driver which
I can take as an example, I would need some help on this.

> Why is this driver submitted to the staging tree?  What is keeping it
> from going into the "real" portion of the kernel for other card readers?

Interrupt handling, read, write and connecting the driver upwards to the
block subsystem, I guess.

> We need a TODO file for what is needed to get it moved out of staging.

I can create one, no problem.

> Oh, and it needs to do a bit more than just detect a card to be useful,
> right?  How about read/write to it?

Sure. My intention was to get feedback for my work as early as possible.
I reached a state where a minimal level of functionality is available:
the mechanical SD card presence is available for userspace programs.

The read/write access will be a bit more difficult, I guess because I
currently don't have access to the register programming reference of
this device, I can use the trial-and-error method, for example.

	Márton Németh



