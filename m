Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab0FCJvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:51:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:38400 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639Ab0FCJvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:51:44 -0400
Message-ID: <4C077B2F.8010204@suse.cz>
Date: Thu, 03 Jun 2010 11:51:43 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.18 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nicolas Palix <npalix@diku.dk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 3/4] Add scripts/coccinelle/kzalloc-simple.cocci
References: <1273508667-5152-1-git-send-email-npalix@diku.dk> <1273508667-5152-4-git-send-email-npalix@diku.dk>
In-Reply-To: <1273508667-5152-4-git-send-email-npalix@diku.dk>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.5.2010 18:24, Nicolas Palix wrote:
> +@script:python depends on org@
> +p << r.p;
> +x << r.x;
> +@@
> +
> +msg="%s" % (x)
> +msg_safe=msg.replace("[","@(").replace("]",")")
> +coccilib.org.print_todo(p[0], msg_safe)
> +
> +@script:python depends on report@
> +p << r.p;
> +x << r.x;
> +@@
> +
> +msg="WARNING: kzalloc should be used for %s, instead of kmalloc/memset" % (x)
> +coccilib.report.print_report(p[0], msg_safe)

msg_safe is not defined in this scriptlet, I'm only getting

Traceback (most recent call last):
  File "<string>", line 5, in <module>
NameError: name 'msg_safe' is not defined

Michal
