Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1HOKzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:55:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1HOKzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:55:01 -0400
Message-ID: <4E48FB04.9010903@suse.cz>
Date: Mon, 15 Aug 2011 12:55:00 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: IS_ENABLED() and non-available symbols
References: <CACqU3MU2pjcqgYDjn=S2asdLamU0mity+kLizH_mbTtJU5Fh2A@mail.gmail.com> <1313341346-15605-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1313341346-15605-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.8.2011 19:02, Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Aug 14, 2011 at 12:55 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> The solution is trivial, but I am not sure we want to go that way: we
>> need to generated a __enabled_ entry for symbols for _all_ symbols in
>> the configuration, even internal one
>>
> That should do the job...
> 
>  -= NOT FOR MERGE =-
> 
> Not-Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> 
> ---
>  scripts/kconfig/confdata.c |   42 +++++++++++++++++++++++++++++++-----------
>  1 files changed, 31 insertions(+), 11 deletions(-)
> 
>  	for_all_symbols(i, sym) {
> +		conf_write_symbol(out_h, sym, &header__enabled_printer_cb, NULL);
> +
>  		sym_calc_value(sym);
>  		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
>  			continue;

I like the approach, it will work even with not visible symbols and
still catch typos (which #ifdef does not protect against). But with the
patch as-is, the generated autoconf.h starts with lots of

#define __enabled_CONFIG_(null) 1
#define __enabled_CONFIG_(null)_MODULE 0
#define __enabled_CONFIG_(null) 1
#define __enabled_CONFIG_(null)_MODULE 0
#define __enabled_CONFIG_(null) 0

Michal
