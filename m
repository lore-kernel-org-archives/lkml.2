Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1CQGk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:40:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52340 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1CQGky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nVv3sFoWIs8mlosfWTiQ+LOAeWdAjhsrc9EyC6LR4Yaj4D8NtR3SJpykcoCjHwv0EG
         75/viLXpstQZETJs/kVi7upUUaQ7JboQ8cb7fx7jzAqf+21P4/9UEJs9GX00gVy/Z4xh
         YNJOlx4hIBKI+KKJ/jmgWzzOxgIN2C1rHlcRA=
MIME-Version: 1.0
In-Reply-To: <20100408135107.19547.5352.stgit@warthog.procyon.org.uk>
References: <20100408135107.19547.5352.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 17 Mar 2011 02:40:31 -0400
X-Google-Sender-Auth: NHdFErtECge5EH21sGPZz_3QZEk
Message-ID: <AANLkTinK43xhXCYNPfbQq-ak+1hZf2+ykr097GASNyoH@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: Work around the lack of vmap()/vunmap() in
 firmware_loading_store() [ver #2]
To: David Howells <dhowells@redhat.com>
Cc: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 09:51, David Howells wrote:
> Work around the lack of vmap()/vunmap() in firmware_loading_store() when
> operating in NOMMU mode.  vmap() cannot be implemented as there's no virtual
> mapping available.
>
> Instead, in NOMMU mode, make available a function (vcoalesce()) that can
> coalesce the supplied data into one big buffer and store as the address vmap()
> would've returned.
>
> This can be #defined to vmap() in NOMMU mode by interested parties.

these things work for us ... were you going to push them up to mainline ?
-mike
