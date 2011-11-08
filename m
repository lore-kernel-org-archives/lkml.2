Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1KHBEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:04:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40421 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1KHBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:04:15 -0500
MIME-Version: 1.0
In-Reply-To: <20111108003622.GM21663@outflux.net>
References: <1320710760-2734-1-git-send-email-bfreed@chromium.org>
	<20111108003622.GM21663@outflux.net>
Date: Mon, 7 Nov 2011 17:04:14 -0800
X-Google-Sender-Auth: lifSNnT_rJASUvXGIfXsNCI93dw
Message-ID: <CAEYUcX3wKfQZGFbRuRHgE8wuc_=Jm+-9s68tb20jkd_yqRHOjA@mail.gmail.com>
Subject: Re: [PATCH] ramoops: Add a device file for ramoops buffer access.
From: Bryan Freed <bfreed@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, msb@chromium.org,
        marco.stornelli@gmail.com, seiji.aguchi@hds.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, we should definitely work together on this.

bryan.

On Mon, Nov 7, 2011 at 4:36 PM, Kees Cook <keescook@chromium.org> wrote:
> Hi Bryan,
>
> On Mon, Nov 07, 2011 at 04:06:00PM -0800, Bryan Freed wrote:
>> Add a /dev/ramoops device file that gives direct access to ramoops buffers.
>> This interface is cleaner than using /dev/mem to access the buffers because
>> we no longer need to lseek() or (for ARM) mmap() to an address specified in
>> the sysfs mem_address file.
>
> This looks pretty good, except that I'd also want to remove all the module
> parameters since this would bypass CONFIG_STRICT_DEVMEM (imagine a
> malicious root user loading this module to spy on RAM via the new
> interface).
>
> Last week I actually wrote an entire seq_file interface for ramoops[1], but
> it seems it shouldn't live in /proc, so it needs to be reworked a bit to
> live in /dev, as you have it.
>
> Perhaps we could merge our efforts?
>
> -Kees
>
> [1] https://gerrit.chromium.org/gerrit/#change,11242
>
> --
> Kees Cook
> ChromeOS Security
>
