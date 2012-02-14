Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab2BNDTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:19:01 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42684 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab2BNDS7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org> <1328671497-20880-1-git-send-email-clchiou@chromium.org>
From: Daniel Kurtz <djkurtz@google.com>
Date: Tue, 14 Feb 2012 11:18:38 +0800
Message-ID: <CAGS+omDWrSyLtDYWAubyc5F=BUqKOnKmCnyWPn5nNcoREar_aw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Input: serio_raw - add monitor/replay debugging interface
To: Che-Liang Chiou <clchiou@chromium.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 11:24 AM, Che-Liang Chiou <clchiou@chromium.org> wrote:
>
> The serio_raw driver is designed to provide "raw access" to mice, keyboards
> etc; thus, a driver accessing serio_raw may live entirely in userland.
>
> However, serio_raw lacks testability.  It is practically impossible to do
> regression tests on changes to a serio_raw -based userland driver.  On the other
> hand, the kernel's input subsystem has good testability support.  With the help
> of tools like utouch-evemu, we may capture and replay input events for evdev
> drivers in regression tests.
>
> This patchset contains extensions to the serio_raw driver which add debugfs
> entries for monitoring and replaying byte sequence between a userland driver
> and device.  These byte sequences can be used in regression tests of the
> userland driver.  This patchset closes the gap between serio_raw and the input
> subsystem regarding testability.
>
> This patchset is successfully applied on kernel version 3.3-rc2.
>
> Che-Liang Chiou (5):
>  Input: serio_raw - return proper result when serio_raw_read fails
>  Input: serio_raw - extract queue interface
>  Input: serio_raw - factor out common pattern of write
>  Input: serio_raw - add debugfs interface
>  Input: serio_raw - implement debugfs interface

For patches 3-5:
Reviewed-by: Daniel Kurtz <djkurtz@google.com>

For patch 1 (and its implication on queue_read() in patch 2, I'd
prefer to hear feedback from the list.

-Daniel

>
>  drivers/input/serio/serio_raw.c |  394 +++++++++++++++++++++++++++++++++------
>  1 files changed, 337 insertions(+), 57 deletions(-)
>
> --
> 1.7.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Daniel Kurtz | Software Engineer | djkurtz@google.com | 650.204.0722
