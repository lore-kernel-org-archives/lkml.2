Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0JRSRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:17:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46947 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0JRSRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aac6WjfvELaSegrxQwg3kEZWULs4W9BAWktA7QJo63CAJy0HKdZTcW3x2Tl1FoSlrS
         iztva+BRIKVxMiBElV5kwS2Jq12J/Hv88VnqxTNi9DTpuz3af/wEg/I8nv+T8sYcP2wV
         sXDevInu8oFzXA0xJir1dI6tRQ1yGUSCgugdQ=
MIME-Version: 1.0
In-Reply-To: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
References: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
Date: Mon, 18 Oct 2010 11:17:28 -0700
Message-ID: <AANLkTinMSbhTkH0zQn_YO7hFF7zkuv-Gj-B0BUFWy5nP@mail.gmail.com>
Subject: Re: [PATCH] bluetooth: fix unaligned access to l2cap conf data
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        steven miao <realmz6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 3:29 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> From: steven miao <realmz6@gmail.com>
>
>
>        case 2:
> -               *((__le16 *) opt->val) = cpu_to_le16(val);
> +               put_unaligned_le16(cpu_to_le16(val), opt->val);
>                break;
>

I think you wanted:
put_unaligned_le16(val, opt->val);

Cheers,

Harvey
