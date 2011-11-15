Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab1KOTDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:03:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab1KOTC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:02:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAB1b2sjW94L3wm5KPRQDacu9dxoD+1LCoX+4m8O2OSNWp-+n0w@mail.gmail.com>
References: <CAB1b2sjW94L3wm5KPRQDacu9dxoD+1LCoX+4m8O2OSNWp-+n0w@mail.gmail.com>
Date: Tue, 15 Nov 2011 20:02:58 +0100
X-Google-Sender-Auth: IgUnNLtE6hTZlVXF-DDhDYKafDg
Message-ID: <CAB1b2sjuqzVMrsomwfx0AqtCezcNGnQs1OxNXDUUep4JdyYUBQ@mail.gmail.com>
Subject: Re: ttyS0 stuck in tty_wait_until_sent when sending break (opened
 with O_NONBLOCK)
From: Domen Puncer <domen@cba.si>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 11:27, Domen Puncer <domen@cba.si> wrote:
> write(3, "\301", 1)                     = 1
> ioctl(3, TCSBRK <unfinished ...>
>

Traced this down to flow control. And ioctl(fd, TCSBRK, 1) is tcdrain,
so it waited.

Sorry for the noise.
