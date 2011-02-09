Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1BIICu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:02:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48949 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1BIICs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 03:02:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CY9NJMFj8dV/gaRo89cNJbKonbbMrL4VKsRpmDg65WcT7NH/Xbj1AdarVDwTDLIEMh
         29ebnObF5CTUqQFXaOQNuRbbM8OgDoEH29bSfMCjnX7+xthDptINzea/Gfqpsf01MeH0
         pBVT5GzjsYkUk6MQqn0lebMhVSd3eGOBIqKJc=
MIME-Version: 1.0
In-Reply-To: <1296568063-12010-2-git-send-email-aghayal@codeaurora.org>
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org> <1296568063-12010-2-git-send-email-aghayal@codeaurora.org>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 9 Feb 2011 16:02:27 +0800
Message-ID: <AANLkTimZ9UwcQp5QQjyHVsRdEAcf6+rL18mCesishPoC@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/7] matrix_keypad: Increase the max limit of rows
 and columns
To: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Trilok Soni <tsoni@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 9:47 PM, Anirudh Ghayal <aghayal@codeaurora.org> wrote:
> From: Trilok Soni <tsoni@codeaurora.org>
>
> Some keyboard controller have support for more than
> 16 columns and rows. Moving this value to 32.
>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>

This looks good to me, as long as the bits don't exceed 256, which
is used in the #KEY() macro. So far, 32 looks to be a sane number
to me, unless we have further requirement to get this larger.

Acked-by: Eric Miao <eric.y.miao@gmail.com>


> ---
> Changes from v1:
> Moved the max columns and rows to 32
>
>  include/linux/input/matrix_keypad.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
> index 6974746..fe7c4b9 100644
> --- a/include/linux/input/matrix_keypad.h
> +++ b/include/linux/input/matrix_keypad.h
> @@ -4,8 +4,8 @@
>  #include <linux/types.h>
>  #include <linux/input.h>
>
> -#define MATRIX_MAX_ROWS                16
> -#define MATRIX_MAX_COLS                16
> +#define MATRIX_MAX_ROWS                32
> +#define MATRIX_MAX_COLS                32
>
>  #define KEY(row, col, val)     ((((row) & (MATRIX_MAX_ROWS - 1)) << 24) |\
>                                 (((col) & (MATRIX_MAX_COLS - 1)) << 16) |\
> --
> 1.7.3.5
>
>
