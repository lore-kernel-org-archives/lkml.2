Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2HJEbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 00:31:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58466 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2HJEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 00:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5Y2nMeYvKhMjPFFa-3tGLOOyxXX1B8MZSbXrMLsNDPJmdmzA@mail.gmail.com>
References: <1343141382-31087-1-git-send-email-benchan@chromium.org>
	<CAHdPZaOTvF=e3j8ypzK8_V5Uh_8Nk1U74uVe4tcXs+cdQvimjg@mail.gmail.com>
	<CAC5Y2nMeYvKhMjPFFa-3tGLOOyxXX1B8MZSbXrMLsNDPJmdmzA@mail.gmail.com>
Date: Fri, 10 Aug 2012 10:00:55 +0530
Message-ID: <CAHdPZaPwUHHUyvgU1N=FAggF5Gg_p7cf-290Yd1+i+9eNyDY1g@mail.gmail.com>
Subject: Re: [PATCH v2] staging: gdm72xx: fix reference counting in gdm_wimax_event_init
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Ben Chan <benchan@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 7:23 PM, Ben Chan <benchan@chromium.org> wrote:
> Hi Devendra,
>
> Thanks for cleaning up the driver.  If I understand the code
> correctly, the original author wanted to initialize wm_event once and
> reuse it for multiple devices, and thus reference counted it with
> ref_cnt.
>
> For instance, each time gdm_usb_probe() is called, it may call
> register_wimax_device() / gdm_wimax_event_init(). wm_event is
> initialized the first time when wm_event.ref_cnt == 0 (alternatively,
> the code could check !wm_event.sock). Subsequent calls to
> gdm_wimax_event_init() will simply increase the ref count. Similarly,
> gdm_usb_disconnect() calls unregister_wimax_device() /
> gdm_wimax_event_exit(), which decreases the ref count and disposes
> wm_event when ref_cnt becomes zero.
>
> The code change in commit 8df858ea76b76dde9a39d4edd9aaded983582cfe
> only prevents ref_cnt from increasing beyond one. So the code no
> longer work when there are multiple devices (i.e. wm_event could be
> disposed even when there is an active device).
>
> Thanks,
> Ben
>
>
Sorry Ben, I didn't saw the mail for a long time,

Thanks a lot for the long explanation, i will keep in mind of these
problems, and also i think your patch is ok.

Thanks,
Devendra.
