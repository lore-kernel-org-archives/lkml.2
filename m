Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab0KRQ7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:59:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46368 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab0KRQ7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:59:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MALSXPRgNKkU8ZQqVMPQ+lya/CnPnhjSa0/3ZUKjBid/weEDBGpZEscJGZOuOKhDlA
         0KkZVtoUCmN9kEqL/g1Q==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011171434320.22190@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com>
	<20101117021000.916235444@intel.com>
	<1290019807.9173.3789.camel@nimitz>
	<alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com>
	<1290030945.9173.4211.camel@nimitz>
	<alpine.DEB.2.00.1011171434320.22190@chino.kir.corp.google.com>
Date: Thu, 18 Nov 2010 08:59:11 -0800
Message-ID: <AANLkTim3-+qDLbXS+Boa-ziNvKkyc-sXK5j0xVstt7tt@mail.gmail.com>
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface to
 support NUMA
From: Aaron Durbin <adurbin@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, shaohui.zheng@intel.com,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 2:44 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 17 Nov 2010, Dave Hansen wrote:
>
>> > Then, export the amount of memory that is actually physically present in
>> > the e820 but was truncated by mem=
>>
>> I _think_ that's already effectively done in /sys/firmware/memmap.
>>
>
> Ok.
>
> It's a little complicated because we don't export each online node's
> physical address range so you have to parse the dmesg to find what nodes
> were allocated at boot and determine how much physically present memory
> you have that's hidden but can be hotplugged using the probe files.
>
> Adding Aaron Durbin <adurbin@google.com> to the cc because he has a patch
> that exports the physical address range of each node in their sysfs
> directories.

Is this something that is needed upstream? I can post it if that is the case.
Sorry, I don't have a lot of context w.r.t. this thread.

>
>> > and allow users to hot-add the memory
>> > via the probe interface.  Add a writeable 'node' file to offlined memory
>> > section directories and allow it to be changed prior to online.
>>
>> That would work, in theory.  But, in practice, we allocate the mem_map[]
>> at probe time.  So, we've already effectively picked a node at probe.
>> That was done because the probe is equivalent to the hardware "add"
>> event.  Once the hardware where in the address space the memory is, it
>> always also knows the node.
>>
>> But, I guess it also wouldn't be horrible if we just hot-removed and
>> hot-added an offline section if someone did write to a node file like
>> you're suggesting.  It might actually exercise some interesting code
>> paths.
>>
>
> Since the pages are offline you should be able to modify the memmap when
> the 'node' file is written and use populate_memnodemap() since that file
> is only writeable in an offline state.
>
