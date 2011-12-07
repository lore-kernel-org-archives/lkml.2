Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1LGCnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:43:21 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:36883 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1LGCnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:43:18 -0500
MIME-Version: 1.0
In-Reply-To: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 7 Dec 2011 10:42:55 +0800
X-Google-Sender-Auth: eoe9thxq0PE45UBAOY4gw4C4Vls
Message-ID: <CAGS+omBvSWz4vBsMDkwk3oge_+k64tqSkrHyF5-C5_LZte_hDw@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] usb/hid-core: drain URB queue when going to suspend
To: jkosina@suse.cz, oneukum@suse.de, bleung@chromium.org
Cc: stern@rowland.harvard.edu, olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 7:23 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
>
> In some situations, trying to suspend a laptop with an attached USB keyboard
> would fail if both NumLock and CapsLock LEDs were lit.
> This was due to a race condition between asynchronously submitted
> LED-manipulating CTRL URBs and the suspend process.
>
> This is a different solution to the same problem highlighted here:
> https://lkml.org/lkml/2011/9/2/391
>
> These patches are against Jiri's hid/for-next branch.
>
> Daniel Kurtz (3):
>  HID: usbhid: remove LED_ON
>  HID: usbhid: hid-core: submit queued urbs before suspend
>  HID: usbhid: defer LED setting to a workqueue
>
> Differences since v1:
>  * Rebase on hid/for-next
>  * Solve race with usbhid_stop() [reported by Oliver Neukum]
>

Hi Jiri,

Any chance you can take a look at this patch set?

-Dan

>  drivers/hid/hid-input.c       |   42 +++++++
>  drivers/hid/usbhid/hid-core.c |  241 ++++++++++++++++++++++++-----------------
>  drivers/hid/usbhid/usbhid.h   |    3 +-
>  include/linux/hid.h           |    2 +
>  4 files changed, 187 insertions(+), 101 deletions(-)
>
> --
> 1.7.3.1
>
