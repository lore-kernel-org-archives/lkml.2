Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0L0O0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:26:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab0L0O0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:26:22 -0500
Message-ID: <4D18A211.8050202@suse.cz>
Date: Mon, 27 Dec 2010 15:26:25 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Peverley <pev@sketchymonkey.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oddity with Kconfig behaviour when using a type definition and
 no prompt
References: <AANLkTinwWpT3S0bNOjX-wTk_wfQ-56Wd7q6WfMmUTO9_@mail.gmail.com>
In-Reply-To: <AANLkTinwWpT3S0bNOjX-wTk_wfQ-56Wd7q6WfMmUTO9_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.2010 20:38, David Peverley wrote:
> This is what I've always expected. Trying the following with a clean
> kernel. However, what happens in the (often used) case of a type definition
> with no prompt e.g.
>       bool
> is not defined in this doc. My _assumption_ would be that it should still
> be used by the config system though :
>
>    bob:linux-2.6.31.14 $ make defconfig
>    *** Default configuration is based on 'x86_64_defconfig'
>    #
>    # configuration written to .config
>    #
>    bob:linux-2.6.31.14 $ printf "\nconfig PEV_TEST\n\tbool\n">>  lib/Kconfig
>    bob:linux-2.6.31.14 $ make oldconfig
>    scripts/kconfig/conf -o arch/x86/Kconfig
>    #
>    # configuration written to .config
>    #


Symbols with no prompt are not prompted for, these can only be set if 
they have a default value or if some other symbol selects them.

Michal
