Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0KJSeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:34:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0KJSeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HQQwAR3QRtLMZ8TtWm4ZmNJBfJDY1AcCDpVMxK7z3NzxR6vGK0lFBfj/NjFACAiay0
         Yc3j/reul/zldkOWPQDZ3NPenhcmq2/hWHT3tgD5GhnqHheAhFn3y+cFc0rr+QOTmygL
         ARHPvi4A5ZsSe9chh5iCAoS2iJTCXmKh1hhU8=
MIME-Version: 1.0
In-Reply-To: <1289393281-4459-2-git-send-email-tsoni@codeaurora.org>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-2-git-send-email-tsoni@codeaurora.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 11 Nov 2010 02:33:45 +0800
Message-ID: <AANLkTi=J2fGOC-RQsPB1SD4GcQ2Df2ZO_a=2mxneHbUa@mail.gmail.com>
Subject: Re: [RFC v1 PATCH 1/6] matrix_keypad: Increase the max limit of rows
 and columns
To: Trilok Soni <tsoni@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 8:47 PM, Trilok Soni <tsoni@codeaurora.org> wrote:
> Some keyboard controller have support for more than
> 16 columns and rows.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
> ---
>  include/linux/input/matrix_keypad.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
> index 80352ad..d80845e 100644
> --- a/include/linux/input/matrix_keypad.h
> +++ b/include/linux/input/matrix_keypad.h
> @@ -4,11 +4,11 @@
>  #include <linux/types.h>
>  #include <linux/input.h>
>
> -#define MATRIX_MAX_ROWS                16
> -#define MATRIX_MAX_COLS                16
> +#define MATRIX_MAX_ROWS                18
> +#define MATRIX_MAX_COLS                18
>
> -#define KEY(row, col, val)     ((((row) & (MATRIX_MAX_ROWS - 1)) << 24) |\
> -                                (((col) & (MATRIX_MAX_COLS - 1)) << 16) |\
> +#define KEY(row, col, val)     ((((row) % (MATRIX_MAX_ROWS)) << 24) |\
> +                                (((col) % (MATRIX_MAX_COLS)) << 16) |\
>                                 (val & 0xffff))
>

Or maybe we can solve this completely by introducing something like:

struct matrix_keycode {
        int row;
        int col;
        int value;
}

And make changes to KEY() macro and other places. You may also want to
eliminate the hardcoded MATRIX_MAX_* in matrix_keypad.c.
>  #define KEY_ROW(k)             (((k) >> 24) & 0xff)
> --
> 1.7.0.2
>
>
