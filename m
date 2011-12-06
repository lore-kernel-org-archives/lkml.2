Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1LFM4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:56:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1LFM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:56:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
Date: Tue, 6 Dec 2011 12:55:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com> <201112051437.27538.arnd@arndb.de> <CACVXFVMB+HuQDb+Pxo0d8x46P82-c-OPxaL0c661Wztyx3NWJA@mail.gmail.com>
In-Reply-To: <CACVXFVMB+HuQDb+Pxo0d8x46P82-c-OPxaL0c661Wztyx3NWJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112061255.56136.arnd@arndb.de>
X-Provags-ID: V02:K0:7uwPm+D32jfOXxjXaq+OzChT4cSe+VnmurWpiH5RBd5
 B6lXWQ9t5JO0hDp4p5gnNBItJ2beMvG5yuCRyBStp0rE532yg0
 2xaH03zhGNuYz/1B/XLBILxP4O7aW2ax0nqSSrlVHJ32Klf1Ew
 3sfyoOzKj5z6WEBSUkrh8iPfj9ZEdZVkjPxy/5eNtOMWHdzoFi
 Jn2d7SsP3jePFqOHDhWpLyh86P/GTtRP5PVAyy51Zf7m9OWF8y
 jQJyS8inHdwp5q6Kr1oRlls/1Y1fK1wA2KX0PySy/aB9w4AWb9
 lMBnFNJ8Az7dNyYdId+a8Crgl+Bmy5UQ89YW3tj/9HYwyw636y
 HmD2JoIkf/tbywMpAQ18=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 December 2011, Ming Lei wrote:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 073eb4d..8aeaa1e 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2214,7 +2214,12 @@ struct v4l2_fd_result {
>         __u32   buf_index;
>         __u32   face_cnt;
>         __u32   reserved[6];
> -       struct v4l2_fd_detection *fd;
> +
> +       /*make 64/32 compatible*/
> +       union {
> +               struct v4l2_fd_detection *fd;
> +               __u64   dummy;
> +       };
>  };
> 

That's not compatible, at least not on any big-endian architecture.
If you want to have an indirect pointer, you have to cast it to the
__u64 member in user space and back in kernel space.

Using an array added to the end of the v4l2_fd_result structure
rather than a pointer would really make this easier IMHO.

	Arnd
