Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2JSRBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:01:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab2JSRBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:01:22 -0400
Message-ID: <5081875D.90105@suse.cz>
Date: Fri, 19 Oct 2012 19:01:17 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kconfig: add a function to get the CONFIG_ prefix
References: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr> <1350589816-20447-3-git-send-email-yann.morin.1998@free.fr>
In-Reply-To: <1350589816-20447-3-git-send-email-yann.morin.1998@free.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.10.2012 21:50, Yann E. MORIN wrote:
> -#ifndef CONFIG_
> -#define CONFIG_ "CONFIG_"
> +/* Those two defines copied from include/linux/stringify.h */
> +#define __stringify_1(x...)	#x
> +#define __stringify(x...)	__stringify_1(x)
> +static inline const char *CONFIG_prefix(void)
> +{
> +	return __stringify(CONFIG_);

This changes the semantics of the CONFIG_ macro. Previously, a
double-quoted string was accepted, now you have to define it to a token
that is turned into a string. Why don't you keep it as before and just do a

return CONFIG_;

in the function?

Michal
