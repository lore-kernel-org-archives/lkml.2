Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2ILWyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:54:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57028 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2ILWyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:54:50 -0400
Message-ID: <505112A3.7080703@ti.com>
Date: Wed, 12 Sep 2012 18:54:27 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-ia64@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <arnd@arndb.de>, <dhowells@redhat.com>, <fenghua.yu@intel.com>,
        <lethal@linux-sh.org>, <linux@arm.linux.org.uk>, <nico@linaro.org>,
        <rob.herring@calxeda.com>, <tony.luck@intel.com>, <tony@atomide.com>,
        <will.deacon@arm.com>
Subject: Re: [PATCH v2] /dev/mem: use phys_addr_t for physical addresses
References: <1347473158-7219-1-git-send-email-cyril@ti.com> <20120912181503.GB12840@kroah.com>
In-Reply-To: <20120912181503.GB12840@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On 9/12/2012 2:15 PM, Greg KH wrote:
> On Wed, Sep 12, 2012 at 02:05:58PM -0400, Cyril Chemparathy wrote:
>> This patch fixes the /dev/mem driver to use phys_addr_t for physical
>> addresses.  This is required on PAE systems, especially those that run
>> entirely out of >4G physical memory space.
>
> What is the symptom if this patch is not applied?  Does it need to be
> backported to older kernels?  If so, which ones?
>

As far as I can tell, this change only benefits platforms where lowmem 
lies outside the 32-bit addressable range.  On the ARM based KeyStone 
platform, all of our memory is located above the 4GB limit at 
0x8:0000:0000.  On this platform, trying to read lowmem breaks as follows:

# dd if==/dev/mem of=/dev/null bs==4k count=1 skip=8388608
dd: /dev/mem: Bad address

Assuming that we are unique in this regard (i.e. lowmem outside 4GB), I 
don't see any reason to backport this to earlier kernels.

-- 
Thanks
- Cyril
