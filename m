Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2LELQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:16:29 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56901 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab2LELQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:16:23 -0500
Message-ID: <50BF2CFB.3030603@imgtec.com>
Date: Wed, 5 Dec 2012 11:16:11 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@ozlabs.org>,
        "David Howells" <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] MODSIGN: Avoid using .incbin in C source
References: <1354616321-13520-2-git-send-email-mmarek@suse.cz> <1354616321-13520-1-git-send-email-mmarek@suse.cz> <22396.1354645048@warthog.procyon.org.uk> <87hao1gyiv.fsf@rustcorp.com.au> <s5hobi9aqxs.wl%tiwai@suse.de> <20121205095057.GA26543@sepie.suse.cz> <50BF2262.7080603@imgtec.com> <50BF2A95.9070704@suse.cz>
In-Reply-To: <50BF2A95.9070704@suse.cz>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_05_11_16_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/12 11:05, Michal Marek wrote:
> Dne 5.12.2012 11:30, James Hogan napsal(a):
>> However I think it's unfortunate having to stringify from C as it's
>> pretty much always required to be in string form when used from a C
>> file, usually in an asm block. Any objection to defining SYMBOL_PREFIX
>> with the quotes around it for _c_flags only? E.g. see below
> 
> 
> After Takashi's patch is applied, there will be no user of the
> SYMBOL_PREFIX in C source. But it would probably be more convenient for
> potential new users.

Yes indeed (so the C related bits could indeed be dropped for now). I'd
likely change this patch to use it though:
http://thread.gmane.org/gmane.linux.kernel.cross-arch/15586/focus=15593

> 
>> +_c_sym_flags = -DSYMBOL_PREFIX=\"$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))\"
> 
> Maybe simply
> 
> -DDSYMBOL_PREFIX='$(or $(CONFIG_SYMBOL_PREFIX),"")'
> 
> ? The single quotes are needed either way, to prevent the shell eating
> the double quotes.

Yep, works for me (makefiles aren't one of my strengths!)

Cheers
James

