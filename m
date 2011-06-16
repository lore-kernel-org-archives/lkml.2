Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1FPKik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1FPKij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:38:39 -0400
Message-ID: <4DF9DD25.1000103@redhat.com>
Date: Thu, 16 Jun 2011 07:38:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Hans Petter Selasky <hselasky@c2i.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: DVB_NET help message is useless
References: <4DF9AB93.1040903@gmail.com>
In-Reply-To: <4DF9AB93.1040903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-06-2011 04:06, Jiri Slaby escreveu:
> Hi,
> 
> I've just updated to 3.0-rc and saw CONFIG_DVB_NET. Hmm, let's see
> what's that by asking with '?'. And I got this crap:
> ================
> CONFIG_DVB_NET:
> 
> The DVB network support in the DVB core can
> optionally be disabled if this
> option is set to N.
> 
> If unsure say Y.
> ================
> Why do you think this help message is useful? It's clear to
> everybody that if one eventually disables it it will be disabled. The
> help message should mention _what_ the network support is.
> 
> I would send a patch, but I really have no idea what's that good for.

As Hans answered this option disables the IP stack from the DVB driver. The
IP stack is part of the DVB standard. It is used, for example, by automatic 
firmware updates used on STB's. It can also be used to access the Internet,
via the DVB card, if the network provider supports it.

Before 3.0, this were enabled on all cards. However, if the IP stack is
disabled, this would mean that the entire DVB would also be disabled.
So, this option were added. It may make sense to make it dependent of
CONFIG_EMBEDDED, as normal users should not need to disable it.

Feel free to send us a patch if you want to improve the Kconfig logic or
help message.

Thanks,
Mauro
