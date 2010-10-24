Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab0JXWKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:10:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047Ab0JXWKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:10:11 -0400
Message-ID: <4CC4AEBB.6000505@suse.cz>
Date: Mon, 25 Oct 2010 00:10:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: don't select 64 bit option on sparc32 all{yes,mod}config
References: <1287762484-8154-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1287762484-8154-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.10.2010 17:48, Namhyung Kim wrote:
> The SPARC architecture provides 64BIT config option to select
> build type and it is set to 1 on ARCH=sparc64 as a default value.
> But in case of 32-bit, it is also set to 1 by the allyesconfig
> logic, end result would be the same as of sparc64. So I think
> it would be better if plain ARCH=sparc all{yes,mod}config do not
> set it then we can test 32-bit build by default.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  scripts/kconfig/confdata.c |    4 ++++

Can't this be fixed in the sparc Makefile/Kconfig instead? E.g. have
ARCH=sparc -> ask
ARCH=sparc64 -> CONFIG_64BIT=y
ARCH=sparc32 -> # CONFIG_64BIT is not set
like the x86/i386/x86_64 ARCH option for x86.

Michal
