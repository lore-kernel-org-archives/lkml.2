Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1IPMbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:31:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab1IPMbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:31:08 -0400
Message-ID: <4E73418B.4050802@suse.cz>
Date: Fri, 16 Sep 2011 14:31:07 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] kbuild: introduce KBUILD_CONFIG; unexpose KCONFIG_CONFIG
References: <1313472854-14426-1-git-send-email-lacombar@gmail.com> <1313472854-14426-2-git-send-email-lacombar@gmail.com>
In-Reply-To: <1313472854-14426-2-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.8.2011 07:34, Arnaud Lacombe wrote:
> Refine the Kbuild interface to expose it's own variable to architecture
> Makefile's and prepare Kconfig environment prior to any %config invocation.
> 
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  Makefile                                |    8 ++++++--
>  arch/arm/boot/compressed/Makefile       |    2 +-
>  arch/unicore32/boot/compressed/Makefile |    2 +-
>  scripts/kconfig/Makefile                |    3 +++
>  4 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index b4ca4e1..26798a4 100644
> --- a/Makefile
> +++ b/Makefile
[...]
> +# Prepare Kconfig environment
> +KCONFIG_CONFIG    = $(KBUILD_CONFIG)
> +export KCONFIG_CONFIG

IMO we should preserve the semantics of KCONFIG_CONFIG as much as
possible. make KCONFIG_CONFIG=blah works, but setting it in the
environment does not, because the '=' assignment take precendence.

Michal
