Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0KTVDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 16:03:55 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48566 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0KTVDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 16:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dl42YJEv/A1rVzng6NM3dVGquyFeh7oFmJQmBtY72DcCQNTe/34x1hBBezO4hW0Xir
         P5uFN5ynTB4qrOXQALgOrDPYbcvrRGcdDDejquTu+D6Hc1FiendN6y8ZDrFLPNiq0e9j
         GkQO3PEA7qxZYg21GGHHhsVnqV5DPEXnCSFi0=
MIME-Version: 1.0
In-Reply-To: <20101120050353.32269.90666.stgit@zaytsev.su>
References: <20101120050353.32269.90666.stgit@zaytsev.su>
Date: Sun, 21 Nov 2010 00:03:53 +0300
Message-ID: <AANLkTi=iVVUCpskSfwFaxPdseft+vLwmfpUhAEjP3RXV@mail.gmail.com>
Subject: Re: [PATCH] Shrink fanotify_event_metadata by 32 bits
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, just so you know, the real motivation is to use the '__u8
reserved' for an offset to the first option's header. This way we
should be able to add a reasonable number of new core fields to struct
fanotify_event_metadata, and still maintain backwards compatibility.
I'd have to add an other __u32 for that purpose, so we are actually
saving 64 bits per event with this patch.

On Sat, Nov 20, 2010 at 08:08, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> There seems to be no point wasting 32 bits for either the event version or length
>
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> ---
>
> Hi.
>
> While I'm working on the file modification events,
> please consider this patch. It obviously breaks
> the userspace ABI. But maybe that's acceptable, given
> that no kernel has ever been released with the old ABI.
>
> And the users only need to recompile their code, without
> changing anything.
>
> If we agree that this change is desirable, please make sure
> it makes it to Linus before the release. ;)
>
>
>  include/linux/fanotify.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
> index 0f01214..9a7986f 100644
> --- a/include/linux/fanotify.h
> +++ b/include/linux/fanotify.h
> @@ -86,10 +86,11 @@
>  #define FANOTIFY_METADATA_VERSION      2
>
>  struct fanotify_event_metadata {
> -       __u32 event_len;
> -       __u32 vers;
> -       __aligned_u64 mask;
> +       __u16 event_len;
> +       __u8 vers;
> +       __u8 reserved;
>        __s32 fd;
> +       __aligned_u64 mask;
>        __s32 pid;
>  };
>
>
>
