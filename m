Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1GYUpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:45:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21807 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1GYUpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:45:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=SjOxn0ou0XzC3/EYs72crsat4NVB4muq6oLN7mzvMjWJIb1iRM5mRQuWaAAnZBR1x
	DJASp90+Nw699s8EeLnYQ==
MIME-Version: 1.0
In-Reply-To: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Mon, 25 Jul 2011 13:45:06 -0700
Message-ID: <CAJniumU-neufdW_AbrtdF4K+jxnP6OuvA94rSXcE4g+eif29wg@mail.gmail.com>
Subject: Re: [PATCH] cgroup:be able to remove the record of unplugged device
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: lizf@cn.fujitsu.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 11:03 PM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> @@ -826,15 +826,15 @@ static int blkio_policy_parse_and_set(char *buf,
>
>        dev = MKDEV(major, minor);
>
> +       if (s[1] == NULL)
> +               return -EINVAL;
> +

How can s[1] be NULL? If there aren't two parameters in the input we'd
have returned earlier since i!=2, and each element in s[] is
initialized from a pointer that has been dereference immediately
beforehand, and hence can't be NULL.

>        ret = blkio_check_dev_num(dev);
> -       if (ret)
> +       if (ret && (strcmp(s[1], "0\0")))
>                return ret;

Better to move the parsing of s[1] ahead of this, and do a numerical
comparison? Otherwise this will miss the case where the input string
is e.g. "8:0 00"

Paul
