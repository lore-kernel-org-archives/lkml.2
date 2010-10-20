Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0JTRFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:05:33 -0400
Received: from claw.goop.org ([74.207.240.146]:51975 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0JTRFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:05:32 -0400
Message-ID: <4CBF2158.7060600@goop.org>
Date: Wed, 20 Oct 2010 10:05:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH v3 08/10] xen: use host E820 map for dom0
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>	<1286901770-8612-8-git-send-email-Stefano.Stabellini@eu.citrix.com>	<20101018155412.GD27373@dumpdata.com> <alpine.DEB.2.00.1010191148550.2423@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1010191148550.2423@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/19/2010 03:49 AM, Stefano Stabellini wrote:
>>> -	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
>>> -
>>> +	for (i = 0; i < memmap.nr_entries; i++) {
>>> +		unsigned long long end = map[i].addr + map[i].size;
>>> +		if (map[i].type == E820_RAM) {
>>> +			if (map[i].addr > mem_end)
>>> +				continue;
>> Would it make sense to print out a message saying something to the
>> effect of: "You need to increase the CONFIG_XEN_MAX_DOMAIN_MEMORY value to
>> take advantage of the extra %d gobs of memory!\n", map[i].size
>>
>> Or will this be unneccessary with the later changes that Jeremy has
>> for the balloon work?
>>
> I think it still makes a lot of sense to print that message because
> ballooning might be disabled.

CONFIG_XEN_MAX_DOMAIN_MEMORY scales the max pfn in the p2m table, and it
independent of whether ballooning is enabled.  The presence or absence
of ballooning will only affect whether memory between memory and maxmem
can be made available.  And it defaults 128G now anyway, so its very
unlikely people will hit it by accident.

Aside from that, I'm thinking of making ballooning mandatory (perhaps
just a config option on the usermode-visible parts), since it seems so
core (its mandatory for all the dom0/passthrough stuff anyway).

    J
