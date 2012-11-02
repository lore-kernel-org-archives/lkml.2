Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2KBNDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:03:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53706 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2KBNDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:03:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMj3urrhy83o1aD4q3K0CqOL6ZrchknmdvgHDWkahavQQA@mail.gmail.com>
References: <1341961393-17728-1-git-send-email-bleung@chromium.org>
	<1351200081-19349-1-git-send-email-bleung@chromium.org>
	<1351200081-19349-2-git-send-email-bleung@chromium.org>
	<CAHR064jAfmmpf-p5Yh=SZWW31kr0JxcA3VNQrCTV=T9U48HQtw@mail.gmail.com>
	<CAOesGMj3urrhy83o1aD4q3K0CqOL6ZrchknmdvgHDWkahavQQA@mail.gmail.com>
Date: Fri, 2 Nov 2012 13:03:44 +0000
Message-ID: <CAHR064gM8sj75Mz1az4pS0wF3fEBcjWMvEjbYRF5pnDirhtjag@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Platform: x86: Add Chrome OS Laptop driver
From: Corentin Chary <corentin.chary@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Benson Leung <bleung@chromium.org>, Matthew Garrett <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, olofj@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 12:45 PM, Olof Johansson <olof@lixom.net> wrote:
> On Fri, Oct 26, 2012 at 10:30 AM, Corentin Chary
> <corentin.chary@gmail.com> wrote:
>
>> Looks better, but I'm curious, what is the final purpose of this driver ?
>> What ABI will be exposed, who will use it ?
>>
>> If it is going to be bigger, it may be a good idea to convert it to a
>> real platform driver (platform_drivers/platform_device stuff).
>
> It's not a driver per se. It's platform glue that, based on the DMI
> table, registers platform and i2c devices (at this time only i2c
> devices).
>
> Unfortunately there's no way to do this nicely from userspace after
> boot, since there's limits to how much data you can provide with the
> simpler userspace-driven i2c probing protocol.
>
> So, there's no user-facing ABI on this, and no one is expected to use
> it from userspace. It's just there to make sure that the un-probably
> devices on this kind of hardware gets bound to drivers properly.
>
> If it's converted to a platform_driver, how do you expect that to
> probe, where would the platform_device be registered?

I guess I would check dmi in the module init method, and then use the
probe callback of platform_create_bundle to do more probing if
necessary.


--
Corentin Chary
http://xf.iksaif.net
