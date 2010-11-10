Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0KJANM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:13:12 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55572 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KJANM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:13:12 -0500
MIME-Version: 1.0
In-Reply-To: <1287771688-14805-29-git-send-email-gregkh@suse.de>
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-29-git-send-email-gregkh@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 10 Nov 2010 01:12:55 +0100
Message-ID: <AANLkTinVp4C9bRW6=EMHwh1UyeadFbOXKe1aDsxknJf8@mail.gmail.com>
Subject: Re: [PATCH 29/49] vcs: add poll/fasync support
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Nicolas Pitre <nicolas.pitre@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 20:21, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> From: Nicolas Pitre <nico@fluxnic.net>
>
> The /dev/vcs* devices are used, amongst other things, by accessibility
> applications such as BRLTTY to display the screen content onto refreshable
> braille displays.  Currently this is performed by constantly reading from
> /dev/vcsa0 whether or not the screen content has changed.  Given the
> default braille refresh rate of 25 times per second, this easily qualifies
> as the biggest source of wake-up events preventing laptops from entering
> deeper power saving states.
>
> To avoid this periodic polling, let's add support for select()/poll() and
> SIGIO with the /dev/vcs* devices.  The implemented semantic is to report
> data availability whenever the corresponding vt has seen some update after
> the last read() operation.  The application still has to lseek() back
> as usual in order to read() the new data.

Shouldn't it raise POLLPRI/POLLERR then, when it's not about new data
to read? We do this for several files in the kernel where we just want
to wakup someone, but the pretty well-defined semantics of poll()
don't apply.

Kay
