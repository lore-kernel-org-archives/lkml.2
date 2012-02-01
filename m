Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2BAPT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:19:58 -0500
Received: from seven.medozas.de ([188.40.89.202]:35593 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab2BAPT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:19:56 -0500
Date: Wed, 1 Feb 2012 16:19:55 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
        Linux Networking Developer Mailing List 
	<netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/6] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
In-Reply-To: <CAFLxGvzgvvfkKQ7r2WWD6jOr+nLCTOE0MvXaMxfCR3HPAHivxg@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1202011616280.26332@frira.zrqbmnf.qr>
References: <1327269381-20748-1-git-send-email-richard@nod.at> <1327269381-20748-2-git-send-email-richard@nod.at> <CAFLxGvzLvdyyaBvh7LCM2+tTmKobK6n8jTRoH8NXd=MVmN4ocA@mail.gmail.com> <alpine.LNX.2.01.1201310208370.7433@frira.zrqbmnf.qr>
 <CAFLxGvwh5J=CR6OzST7ok6cEuHPWTziDN5TSbGxAiJOpANpAAQ@mail.gmail.com> <alpine.LNX.2.01.1202011523590.18699@frira.zrqbmnf.qr> <CAFLxGvzgvvfkKQ7r2WWD6jOr+nLCTOE0MvXaMxfCR3HPAHivxg@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-02-01 16:08, richard -rw- weinberger wrote:
>> I don't see that extra pointer (outside xt_log_info_v1) that you talk about.
>> +struct xt_log_info_v1 {
>> +       unsigned char level;
>> +       unsigned char logflags;
>> +       char prefix[30];
>> +
>> +       char ring_name[30];
>> +       unsigned long ring_size;
>> +       struct xt_LOG_ring_ctx *rctx;
>> +};
>
>See:
>include/linux/netfilter/xt_LOG.h (user space part).
>
>+struct xt_log_info_v1 {
>+       unsigned char level;
>+       unsigned char logflags;
>+       char prefix[30];
>+
>+       char ring_name[30];
>+       unsigned long ring_siVs.ze;
>+};
>
>Here is no context pointer.

Aw don't do that. That is not maintainer-friendly (since headers
are more or less regularly updated by copying from kernel sources).
Keep the structs the same on each side.

That's why we have .userspacesize in the first place.
See libxt_quota.c on how it's done.

	.size = XT_ALIGN(sizeof(struct xt_log_info_v1)),
	.userspacesize = offsetof(struct xt_log_info_v1, firstkernelmember),
