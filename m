Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1HSMwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:52:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33091 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1HSMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:52:10 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Per Forlin" <per.forlin@linaro.org>
Cc: "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Per Forlin" <per.forlin@stericsson.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
References: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
 <op.v0esx9lx3l0zgt@mnazarewicz-glaptop>
 <CAJ0pr18LYtsPXghNeL_z4qvpd9Td3KtGR4R-x2dfu8s_S+dfYg@mail.gmail.com>
 <op.v0gitehx3l0zgt@mnazarewicz-glaptop>
 <CAJ0pr1_3xdm3qB=AkcuriMpV6RP-47pg+YLNB7YwPuagA0vnEg@mail.gmail.com>
Date: Fri, 19 Aug 2011 14:52:07 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0goo5cc3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <CAJ0pr1_3xdm3qB=AkcuriMpV6RP-47pg+YLNB7YwPuagA0vnEg@mail.gmail.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 13:42:08 +0200, Per Forlin <per.forlin@linaro.org>  
wrote:
> Is it true that fsg_common_init() will never be called twice to
> initialise the same fsg_common structure. It is always called once
> followed by release.
> If this is the case it is safe to only:
> if (common->buffhds)
>   common->buffhds = kzalloc()

You should just always do common->buffhds = kcalloc(fsg_num_buffhds,
sizeof *common->buffhds, GFP_KERNEL) in fsg_common_init() and then
kfree() in release.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
