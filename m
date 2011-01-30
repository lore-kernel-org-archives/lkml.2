Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1A3OxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 09:53:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52122 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1A3OxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 09:53:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DfvJstk+PzE5b4h3bV29gQKdgOhf4F3OoPFhdT3q82gLgC+jY3asI/rIUonFjtUM6b
         UL3q1y4ym1mDjBXHadnmuB2hVwZGO0vU0S/AXSIparsHtxTRQ3gBxwAdVEjOQpHZIDgo
         8aPKC9iw30evouOjEm+rF79lFbcNZyZOEfxMA=
Subject: Re: [PATCH] mtd: fix memory leak
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1296379908-10150-1-git-send-email-minipli@googlemail.com>
References: <1296379908-10150-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 16:52:33 +0200
Message-ID: <1296399153.2388.57.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2011-01-30 at 10:31 +0100, Mathias Krause wrote:
> diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
> index 5239328..8d28fa0 100644
> --- a/drivers/mtd/devices/phram.c
> +++ b/drivers/mtd/devices/phram.c
> @@ -117,6 +117,7 @@ static void unregister_devices(void)
>  	list_for_each_entry_safe(this, safe, &phram_list, list) {
>  		del_mtd_device(&this->mtd);
>  		iounmap(this->mtd.priv);
> +		kfree(this->mtd.name);
>  		kfree(this);
>  	}

Since register_device() did not allocate it, unregister_devices() should
not free it. Hence, I think it is better to free(name) just after
calling unregister_devices().

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

