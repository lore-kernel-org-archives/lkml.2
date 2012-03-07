Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2CGRmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:42:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47311 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab2CGRl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:41:57 -0500
Message-ID: <4F579DE0.3050400@wwwdotorg.org>
Date: Wed, 07 Mar 2012 10:41:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] Kbuild: centralize MKIMAGE and cmd_uimage definitions
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org> <201203062256.16105.vapier@gentoo.org>
In-Reply-To: <201203062256.16105.vapier@gentoo.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 08:56 PM, Mike Frysinger wrote:
> On Tuesday 06 March 2012 19:30:36 Stephen Warren wrote:
>> --- a/arch/blackfin/boot/Makefile
>> +++ b/arch/blackfin/boot/Makefile
>>
>> +ifeq ($(CONFIG_RAMKERNEL),y)
>> +UIMAGE_LOADADDR = $(CONFIG_BOOT_LOAD)
>> +else # CONFIG_ROMKERNEL must be set
>> +UIMAGE_LOADADDR = $(CONFIG_BOOT_LOAD)
>> +endif
> 
> this part is wrong :).  the else branch should be $(CONFIG_ROM_BASE).

Thanks. I've fixed that locally.

>> +UIMAGE_ENTRYADDR = $(shell $(NM) vmlinux | awk '$$NF == "__start" {print
>> $$1}')
> 
> i feel like if we tried harder, we could automate the -e arg for all arches.  
> i understand if you don't want to undertake that though.

Yes, this might be possible. I'd guess the symbol name varies between
archs, but that can probably be taken care of. This is probably best
left as a follow-on patch though, since it's a behavioral change,
whereas this patch is just consolidation.
