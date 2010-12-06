Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0LFSQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:16:25 -0500
Received: from waste.org ([173.11.57.241]:45619 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab0LFSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:16:23 -0500
Subject: Re: [PATCH 0/7] printk: add pr_<level>_once, guard print_hex_dump
From: Matt Mackall <mpm@selenic.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291659120.17494.179.camel@Joe-Laptop>
References: <cover.1291611190.git.joe@perches.com>
	 <1291649869.3065.2095.camel@calx>  <1291659120.17494.179.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 12:16:20 -0600
Message-ID: <1291659380.3065.2214.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 10:12 -0800, Joe Perches wrote:
> On Mon, 2010-12-06 at 09:37 -0600, Matt Mackall wrote:
> > On Sun, 2010-12-05 at 21:44 -0800, Joe Perches wrote:
> > > There are many uses of printk_once(KERN_<level>.
> > > Add pr_<level>_once macros to avoid printk_once(KERN_<level> pr_fmt(fmt).
> > > Add an #ifdef CONFIG_PRINTK for print_hex_dump and static inline void
> > > functions for the #else cases to reduce embedded code size.
> > > Neaten and organize the rest of the code.
> > Looks fine to me. I'd missed the introduction of the pr_<level> macros
> > and I'm not sure if I like the idea, but this is a tidy and
> > well-presented cleanup and extension.
> > Acked-by: Matt Mackall <mpm@selenic.com>
> 
> The #ifdef CONFIG_PRINTK guard for print_hex_dump saves ~200
> bytes in an x86 !CONFIG_PRINTK
> 
> There could be ~500 bytes more saved if hex_dump_to_buffer
> was compiled out.

Can't say I'm excited by this approach. .5k is under my threshold for
this level of invasiveness.

-- 
Mathematics is the supreme nostalgia of our time.


