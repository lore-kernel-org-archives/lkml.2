Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0E3PcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:32:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56358 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0E3PcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kmIa0UHJf6qvBtZzK/tC9CFVyuL7YHO/01j/yxV0YWTHrh6b1fTnGcn0qjkOLVD+tN
         egb96S07tpGRVig7qGhWqxXg2caOrQlH06Nicm1RDo+1WswexfQDLpRENg8+JJ+NHdAv
         6iJpeCYwlZAYyIcQZtfMzkRDakAMdXJ/so89Y=
Message-ID: <4C0284FF.4080707@gmail.com>
Date: Sun, 30 May 2010 17:32:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
CC: Richard Zidlicky <rz@linux-m68k.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: schedule inside spin_lock_irqsave?
References: <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com>
In-Reply-To: <4C028336.8030704@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2010 05:24 PM, Jiri Slaby wrote:
> struct smscore_buffer_t *get_entry(void)
> {
>   struct smscore_buffer_t *cb = NULL;
>   spin_lock_irqsave(&coredev->bufferslock, flags);
>   if (!list_empty(&coredev->buffers)) {
>     cb = (struct smscore_buffer_t *) coredev->buffers.next;

Looking at the smscore_buffer_t definition, this is really ugly since it
relies on entry being the first in the structure. It should be
list_first_entry(&coredev->buffers, ...) instead, cast-less.

>     list_del(&cb->entry);
>   }
>   spin_unlock_irqrestore(&coredev->bufferslock, flags);
>   return cb;
> }


-- 
js
