Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1LYVng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 16:43:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35953 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1LYVnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 16:43:33 -0500
MIME-Version: 1.0
X-Originating-IP: [91.17.180.137]
In-Reply-To: <1324115710-14756-1-git-send-email-thilo@ginkel.com>
References: <1324115710-14756-1-git-send-email-thilo@ginkel.com>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Sun, 25 Dec 2011 22:43:09 +0100
Message-ID: <CANvSZQ_y6uZSGgF28+AH+se-ecg+sHhy6pzo7++YvqtArHsUMg@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: cdc-acm: Fix acm_tty_hangup() vs.
 acm_tty_close() race
To: oliver@neukum.name, gregkh@suse.de
Cc: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

On Sat, Dec 17, 2011 at 10:55, Thilo-Alexander Ginkel <thilo@ginkel.com> wrote:
> There is a race condition involving acm_tty_hangup() and acm_tty_close() where
> hangup() would attempt to access tty->driver_data without proper locking and
> NULL checking after close() has potentially already set it to NULL.
> One possibility to (sporadically) trigger this behavior is to perform a
> suspend/resume cycle with a running WWAN data connection.
>
> This patch addresses the issue by introducing a NULL check for
> tty->driver_data in acm_tty_hangup() protected by open_mutex and exiting
> gracefully when hangup() is invoked on a device that has already been closed.

just wondering: Is there any chance that this patch will make it into
3.3? I would really appreciate that as the bug it fixes is pretty
annoying (and potentially causes data loss when the laptop locks up on
resume) and I am sure that I am not the only one affected by it (at
least all Lenovo T420s with an Ericsson F5521gw WWAN modem should be
similarly affected).

If you would like to see any changes to the code or commit message
before considering the patch for inclusion, please let me know.

Thanks,
Thilo
