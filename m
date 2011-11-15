Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab1KOLsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:48:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60070 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1KOLsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <20111115112151.GA3002@albatros>
References: <20111115112151.GA3002@albatros>
Date: Tue, 15 Nov 2011 19:48:15 +0800
Message-ID: <CAM_iQpUAqDmP571R3NkYOmPC7yAEMaHTFmmQCm5hLUXV5Fh8xQ@mail.gmail.com>
Subject: Re: [RFC 1/3] procfs: parse mount options
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAFBmVV9023350

On Tue, Nov 15, 2011 at 7:21 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> +
> +static int proc_parse_options(char *options, struct pid_namespace *pid)
> +{
> + Â  Â  Â  char *p;
> + Â  Â  Â  substring_t args[MAX_OPT_ARGS];
> + Â  Â  Â  int option;


'option' is unused?

> +
> + Â  Â  Â  pr_debug("proc: options = %s\n", options);
> +
> + Â  Â  Â  if (!options)
> + Â  Â  Â  Â  Â  Â  Â  return 1;
> +
> + Â  Â  Â  while ((p = strsep(&options, ",")) != NULL) {
> + Â  Â  Â  Â  Â  Â  Â  int token;
> + Â  Â  Â  Â  Â  Â  Â  if (!*p)
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  continue;
> +
> + Â  Â  Â  Â  Â  Â  Â  args[0].to = args[0].from = 0;
> + Â  Â  Â  Â  Â  Â  Â  token = match_token(p, tokens, args);
> + Â  Â  Â  Â  Â  Â  Â  switch (token) {
> + Â  Â  Â  Â  Â  Â  Â  default:


This switch block reads odd...

> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  pr_err("proc: unrecognized mount option \"%s\" "
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â "or missing value", p);

"\n" is needed.

> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return 0;
> + Â  Â  Â  Â  Â  Â  Â  }
> + Â  Â  Â  }
> +
> + Â  Â  Â  return 1;
> +}


Regards.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
