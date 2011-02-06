Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1BFPJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:09:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62279 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1BFPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=STA28p5POhKpxUneM7S1s7ClnPix1G5padFs3fQ/XGlW5graAiAPji36kTd53Lgosp
         7vIyuHYaWW6GWBRlvPh23MpNQ2z6JTc3ZMMcRHzDTYXA5ZB3fqW33zPNcjf/DjkWA7DJ
         dwTuNI6vGKpZTGeK3tcC1oGkVuTmsmfrpHu1Q=
Subject: Re: [PATCH] mtd: fix memory leak
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org
In-Reply-To: <168EA60D-68D1-4281-A0C2-22B2B598AFE1@googlemail.com>
References: <1296379908-10150-1-git-send-email-minipli@googlemail.com>
	 <1296399153.2388.57.camel@localhost>
	 <168EA60D-68D1-4281-A0C2-22B2B598AFE1@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 17:08:19 +0200
Message-ID: <1297004899.4460.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-30 at 18:35 +0100, Mathias Krause wrote:
> On 30.01.2011 at 15:52, Artem Bityutskiy wrote:
> > Hi,
> > 
> > On Sun, 2011-01-30 at 10:31 +0100, Mathias Krause wrote:
> >> diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
> >> index 5239328..8d28fa0 100644
> >> --- a/drivers/mtd/devices/phram.c
> >> +++ b/drivers/mtd/devices/phram.c
> >> @@ -117,6 +117,7 @@ static void unregister_devices(void)
> >> 	list_for_each_entry_safe(this, safe, &phram_list, list) {
> >> 		del_mtd_device(&this->mtd);
> >> 		iounmap(this->mtd.priv);
> >> +		kfree(this->mtd.name);
> >> 		kfree(this);
> >> 	}
> > 
> > Since register_device() did not allocate it, unregister_devices() should
> > not free it.
> 
> I agree with you, the internal API is a little quirky regarding that point. register_device() should strdup() the name and not just blindly use it. But since the memory for name was already allocated via kmalloc() in phram_setup() it seems a little nitpicky to copy it once again in register_device().
> 
> > Hence, I think it is better to free(name) just after
> > calling unregister_devices().
> 
> This is not possible because unregister_devices() unregisters all devices, not just a single instance. Though name must be freed for every object in the list. After unregister_devices() returns the list is empty and no pointer to the memory locations do exist any more. So my patch was the straight forward fix for the memory leak.

OK, I agree, I think this patch is good enough, pushed to l2-mtd-2.6.git
tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

