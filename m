Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2A0VIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:08:18 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:32969
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752378Ab2A0VIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:08:16 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F231234.5030007@freescale.com>
Date: Fri, 27 Jan 2012 15:08:04 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0.1) Gecko/20111221 Firefox/9.0.1 SeaMonkey/2.6.1
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: <linux-watchdog@vger.kernel.org>, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: fix GETTIMEOUT ioctl in booke_wdt
References: <1327605870-9226-1-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1327605870-9226-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Artamonow wrote:
> +#ifdef	CONFIG_FSL_BOOKE
> +		return put_user(period_to_sec(booke_wdt_period), p);
> +#else

period_to_sec() returns an unsigned long long, which means that the driver
will write 8 bytes instead of 4 to user space.  You need to use a
temporary u32, just like WDIOC_SETTIMEOUT:

		if (get_user(tmp, p))
			return -EFAULT;


-- 
Timur Tabi
Linux kernel developer at Freescale

