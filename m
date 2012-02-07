Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2BGKfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:35:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab2BGKfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:35:15 -0500
Message-ID: <4F30FE61.3060703@suse.cz>
Date: Tue, 07 Feb 2012 11:35:13 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: kconfig: tristate choice with depender choice
References: <20120207.091612.181444339.anemo@mba.ocn.ne.jp>
In-Reply-To: <20120207.091612.181444339.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added Arnaud to CC)

On 7.2.2012 01:16, Atsushi Nemoto wrote:
> If a tristate choice has another choice dependers, kconfig produce
> wrong value.
> 
> Example:
> 
> choice
> 	prompt "choice list AB"
> config A
> 	tristate "a"
> config B
> 	tristate "b"
> endchoice
> choice
> 	prompt "choice list CD"
> 	depends on A
> config C
>        	bool "c"
> config D
>        	bool "d"
> endchoice
> 
> kconfig outputs CONFIG_A=m from defconfig with CONFIG_A=y.
> 
> This happens if the choice list CD depends on A.
> Also, if defconfig contains CONFIG_A=y and "# CONFIG_B is not set",
> output is correct.
> 
> I found commit a64b44ea ("kconfig: fix tristate choice with minimal
> config"), but this problem still exists on v3.3-rc1.  More fix is
> needed for choice with dependers?
> 
> ---
> Atsushi Nemoto

