Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2JDNTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:19:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43689 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab2JDNTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:19:40 -0400
Message-ID: <506D8CA1.2090306@ti.com>
Date: Thu, 4 Oct 2012 18:48:25 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@infradead.org>, <arm@kernel.org>,
        <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 14/17] ARM: davinci: don't mark da850_register_cpufreq
 as __init
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-15-git-send-email-arnd@arndb.de>
In-Reply-To: <1349195816-2225-15-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2012 10:06 PM, Arnd Bergmann wrote:
> The mityomapl138_cpufreq_init and read_factory_config function in
> board-mityomapl138.c are not __init functions and might be called
> at a later stage, so da850_register_cpufreq must not be __init either.
> 
> Without this patch, building da8xx_omapl_defconfig results in:
> 
> WARNING: arch/arm/mach-davinci/built-in.o(.text+0x2eb4): Section mismatch in reference from the function read_factory_config() to the function .init.text:da850_register_cpufreq()
> The function read_factory_config() references
> the function __init da850_register_cpufreq().
> This is often because read_factory_config lacks a __init
> annotation or the annotation of da850_register_cpufreq is wrong.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>

Acked-by: Sekhar Nori <nsekhar@ti.com>

Regards,
Sekhar
