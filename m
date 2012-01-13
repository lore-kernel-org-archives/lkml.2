Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2AMFmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 00:42:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51002 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2AMFmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 00:42:08 -0500
MIME-Version: 1.0
In-Reply-To: <1326402935-31002-1-git-send-email-taysom@chromium.org>
References: <1326402935-31002-1-git-send-email-taysom@chromium.org>
Date: Fri, 13 Jan 2012 00:42:07 -0500
Message-ID: <CA+5PVA7Yffs3-qdq6pSqDKLLngU7kBsdE92e31NnAM0=wrwp4w@mail.gmail.com>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Taysom <taysom@chromium.org>
Cc: Paul Taysom <taysom@google.com>, Mandeep Baines <msb@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Greg KH <greg@kroah.com>,
        Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@google.com>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 4:15 PM, Paul Taysom <taysom@chromium.org> wrote:
> From: Paul Taysom <taysom@google.com>
>
> A USB stick with a ext file system on it, would occasionally crash
> when the stick was pulled.
>
> The problem was a timer was being set on the Backing Device Interface,
> bdi, after the USB device had been removed and the bdi had been
> unregistered. The bdi would then be later reinitialized by zeroing
> the timer without removing from the timer from the timer queue.
> This would eventually result in a kernel crash (NULL ptr dereference).

What backtrace did you see when it crashed?  There have been a number of
reports where sd_revalidate_disk is at the top of the backtrace and this sounds
like it might be related.

josh
