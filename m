Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993196Ab2KOKaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:30:04 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:35295 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992442Ab2KOKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:30:02 -0500
Message-ID: <50A4C3E7.8020304@synopsys.com>
Date: Thu, 15 Nov 2012 15:58:55 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>
Subject: Re: [RFC Patch v1 37/55] ARC: dynamic loadable module support
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-7-git-send-email-vgupta@synopsys.com> <201211121353.15314.arnd@arndb.de>
In-Reply-To: <201211121353.15314.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012 07:23 PM, Arnd Bergmann wrote:
> On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
>> +void *module_alloc(unsigned long size)
>> +{
>> +       if (size == 0)
>> +               return NULL;
>> +
>> +       return vmalloc(size);
>> +
>> +}
>> +
>> +void module_free(struct module *module, void *region)
>> +{
>> +       vfree(region);
>> +}
>> +
>> +int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
>> +                             char *secstr, struct module *mod)
>> +{
>> +    return 0;
>> +}
>> +
>> +void module_arch_cleanup(struct module *mod)
>> +{
>> +}
>> +
>> +int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
>> +                   struct module *mod)
>> +{
>> +    return 0;
>> +} 
> All of these are identical to the default implementation in kernel/module.c
> and you can simply drop your own definitions.

Alloc/free dropped. Rest 3 needed for ARC specific unwinding out of
loadable modules.

>
> 	Arnd

