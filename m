Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1HPLDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 07:03:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45311 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1HPLDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 07:03:21 -0400
MIME-Version: 1.0
In-Reply-To: <1312027319-1402-1-git-send-email-minipli@googlemail.com>
References: <1312027319-1402-1-git-send-email-minipli@googlemail.com>
Date: Tue, 16 Aug 2011 13:03:20 +0200
Message-ID: <CA+rthh_AW5Yz2ZiOqOTWquXKnsDEd=YcNQ9HiOWu-deSar0eWQ@mail.gmail.com>
Subject: Re: [PATCH] tty: clearify structure initializer in notify_write()
From: Mathias Krause <minipli@googlemail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, Greg?

On Sat, Jul 30, 2011 at 2:01 PM, Mathias Krause <minipli@googlemail.com> wrote:
> Even though this is valid C we should not mix C99 initializers with
> obfuscated ANSI C. Stick to C99 and initialize c by its name.
>
> Found by clang:
> drivers/tty/vt/vt.c:262:55: warning: explicitly assigning a variable of
> type 'unsigned int' to itself [-Wself-assign]
>    struct vt_notifier_param param = { .vc = vc, unicode = unicode };
>                                                 ~~~~~~~ ^ ~~~~~~~
>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  drivers/tty/vt/vt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index b3915b7..e716839 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -259,7 +259,7 @@ EXPORT_SYMBOL_GPL(unregister_vt_notifier);
>
>  static void notify_write(struct vc_data *vc, unsigned int unicode)
>  {
> -       struct vt_notifier_param param = { .vc = vc, unicode = unicode };
> +       struct vt_notifier_param param = { .vc = vc, .c = unicode };
>        atomic_notifier_call_chain(&vt_notifier_list, VT_WRITE, &param);
>  }
>
> --
> 1.5.6.5
