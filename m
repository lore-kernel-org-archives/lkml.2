Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab2K3Ted (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:34:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50125 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736Ab2K3Te2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:34:28 -0500
Message-ID: <50B90A3E.4080203@wwwdotorg.org>
Date: Fri, 30 Nov 2012 12:34:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        Mark Salter <msalter@redhat.com>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au, Chris Zankel <chris@zankel.net>,
        linux-xtensa@linux-xtensa.org, Max Filippov <jcmvbkbc@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH V7 1/7] kbuild: centralize .dts->.dtb rule
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org> <50B8D86E.1080109@gmail.com>
In-Reply-To: <50B8D86E.1080109@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 09:01 AM, Rob Herring wrote:
> On 11/27/2012 05:29 PM, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> All architectures that use cmd_dtc do so in almost the same way. Create
>> a central build rule to avoid duplication. The one difference is that
>> most current uses of dtc build $(obj)/%.dtb from $(src)/dts/%.dts rather
>> than building the .dtb in the same directory as the .dts file. This
>> difference will be eliminated arch-by-arch in future patches.
>>
>> MIPS is the exception here; it already uses the exact same rule as the
>> new common rule, so the duplicate is removed in this patch to avoid any
>> conflict. arch/mips changes courtesy of Ralf Baechle.
>>
>> Update Documentation/kbuild to remove the explicit call to cmd_dtc from
>> the example, now that the rule exists in a centralized location.
>>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Jonas Bonn <jonas@southpole.se>
>> Cc: linux@lists.openrisc.net
>> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
>> Cc: linux-c6x-dev@linux-c6x.org
>> Cc: Mark Salter <msalter@redhat.com>
>> Cc: Michal Simek <monstr@monstr.eu>
>> Cc: microblaze-uclinux@itee.uq.edu.au
>> Cc: Chris Zankel <chris@zankel.net>
>> Cc: linux-xtensa@linux-xtensa.org
>> Cc: Max Filippov <jcmvbkbc@gmail.com>
>> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> This is based on next-20121126.
>>
> 
> I'll apply the series but I need a stable base. Looks like xtensa has
> the dependency. Or I can just drop xtensa.

I was assuming this series would be applied for 3.9, hence hadn't
rebased it onto anything stable yet. Are you wanting to apply it
earlier? If so, I'll look into how it fits on top of 3.7-rc7.
