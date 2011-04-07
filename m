Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1DGNup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:50:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:64431 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab1DGNuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:50:44 -0400
Message-ID: <4D9DC0E8.5080705@windriver.com>
Date: Thu, 07 Apr 2011 08:49:28 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] module: Use the binary search for symbols resolution
References: <1302024146-2608-1-git-send-email-abogani@kernel.org> <1302024146-2608-2-git-send-email-abogani@kernel.org>
In-Reply-To: <1302024146-2608-2-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Apr 2011 13:49:29.0555 (UTC) FILETIME=[9DD42A30:01CBF52A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 12:22 PM, Alessio Igor Bogani wrote:
> Let the linker sort the exported symbols and use the binary search for locate them.
>

It would be nice if this patch header included some of the information from introduction message, that asside the technical content looks good.

> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>

Reviewed-by: Jason Wessel <jason.wessel@windriver.com>


>  static bool find_symbol_in_section(const struct symsearch *syms,
>  				   struct module *owner,
>  				   unsigned int symnum, void *data)
>  {
>  	struct find_symbol_arg *fsa = data;
>  
> -	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
> -		return false;
> -
>  	if (!fsa->gplok) {
>  		if (syms->licence == GPL_ONLY)
>  			return false;


This was the only part I had a hard time following, but after having looked at the original source to kernel/module.c, I see how this was optimized and agree.

This looks like a very nice speed up for large interdependent kernel modules.

Cheers,
Jason.
