Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0LGKsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:48:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44021 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab0LGKso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:48:44 -0500
MIME-Version: 1.0
In-Reply-To: <20101207091653.GA22416@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se> <20101207091653.GA22416@core.coreip.homeip.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 7 Dec 2010 11:48:28 +0100
Message-ID: <AANLkTimnSsfCG0WtDpa-qEu3N1uMOeo+CzzZ8wsaZN1v@mail.gmail.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 10:16, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Henrik,
>
> On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
>> Today, userspace sets up an input device based on the data it emits.
>> This is not always enough; a tablet and a touchscreen may emit exactly
>> the same data, for instance, but the former should be set up with a
>> pointer whereas the latter does not need to. Recently, a new type of
>> touchpad has emerged where the buttons are under the pad, which changes
>> handling logic without changing the emitted data. This patch introduces
>> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
>> about the device resulting in proper setup.
>
> If we agree that the new ioctl is suitable we'llalso need to wireit up
> through sysfs. Also, can we keep all definitions to INPUT_ namespace?

Please don't add new ioctls which are not extensible. The ioctl should
carry the length or the version of the structure it asks for, so it
can be extended in the future. Sysfs should be good enough for such
interface though.

Kay
