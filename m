Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab1GZNB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:01:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58502 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GZNBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
References: <4E1D9C25.8080300@suse.cz>
	<1311634718-32588-1-git-send-email-mmarek@suse.cz>
Date: Tue, 26 Jul 2011 21:01:50 +0800
Message-ID: <CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(), KCONFIG_BUILTIN()
 and KCONFIG_MODULE()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, lacombar@gmail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 6:58 AM, Michal Marek <mmarek@suse.cz> wrote:
> Replace the config_is_*() macros with a variant that allows for grepping
> for usage of CONFIG_* options in the code. Usage:
>
>  if (KCONFIG(CONFIG_NUMA))
>
> or
>
>  #if KCONFIG(CONFIG_NUMA)
>
> The KCONFIG() macro evaluates to 1 if the argument is set (to either 'y'
> or 'm'), KCONFIG_BUILTIN() and KCONFIG_MODULE() test if the respective
> option is 'y' and 'm', respectively.

I think it's better to let KCONFIG_MODULE() returns true only for =m, so that
KCONFIG() will equal to KCONFIG_BUILTIN() || KCONFIG_MODULE().

BTW, the name KCONFIG(CONFIG_NUMA) seems ugly.
