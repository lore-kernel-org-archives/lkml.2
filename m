Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HAJYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:24:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab1HAJYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:24:17 -0400
Message-ID: <4E3670BF.6000709@suse.cz>
Date: Mon, 01 Aug 2011 11:24:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@verizon.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        rdunlap@xenotime.net
Subject: Re: [PATCH RFC] kconfig.h fix extraneous dependencies
References: <alpine.LNX.2.00.1107311812460.62769@linux> <CACqU3MWfOg+ZhUGAovWsds48Y37i7GRk7qSxWvt7-JmLMBcmgg@mail.gmail.com> <alpine.LNX.2.00.1107312055360.20006@linux>
In-Reply-To: <alpine.LNX.2.00.1107312055360.20006@linux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.8.2011 03:16, Peter Foley wrote:
> On Sun, 31 Jul 2011, Arnaud Lacombe wrote:
>> On Sun, Jul 31, 2011 at 8:36 PM, Peter Foley<pefoley2@verizon.net>  wrote:
>>> The introduction of kconfig.h caused fixdep to create three extraneous
>>> dependencies.
>>> include/config/.h
>>> include/config/h.h
>>> include/config/foo.h
>>>
>>> Remove them by eliminating instances of CONFIG_
>>>
>> this seems ugly to me... I would rather try to fix fixdep, no ?
>>
>>   - Arnaud
>
> I'd be the first to admit that this patch is a ugly hack.
> However, judging by the comments in fixdep.c this is expected behavior.

And it's also harmless, the source contains thousands of false matches:
$ git grep '_CONFIG_' | wc -l
7989
e.g anything that includes include/linux/acpi.h gets a false dependency 
on include/config/support.h because of
include/linux/acpi.h:#define OSC_EXT_PCI_CONFIG_SUPPORT         1
but it doesn't matter.


> I'm also afraid that changing fixdep to ignore comments would slow down
> the whole build for the sake of one file which IMHO dosen't seem to be a
> worthwhile tradeoff.

I would take a patch that makes fixdep ignore include/linux/kconfig.h, 
like it ignores include/generated/kconfig.h. Anything more advanced 
isn't worth the effort, IMO.

Michal
