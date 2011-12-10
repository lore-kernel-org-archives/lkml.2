Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab1LJFDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 00:03:22 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48008 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1LJFDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 00:03:21 -0500
Message-ID: <4EE2E7ED.6080202@linux.vnet.ibm.com>
Date: Sat, 10 Dec 2011 10:32:37 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Amerigo Wang <amwang@redhat.com>, Kexec-ml <kexec@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Milton Miller <miltonm@bga.com>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Anton Blanchard <anton@samba.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH v5 1/9] fadump: Add documentation for firmware-assisted
 dump.
References: <20111115151145.16533.16384.stgit@mars.in.ibm.com> <20111115151334.16533.5790.stgit@mars.in.ibm.com> <20111124223410.GB19828@bloggs.ozlabs.ibm.com>
In-Reply-To: <20111124223410.GB19828@bloggs.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120918-6102-0000-0000-0000005F9D4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 04:04 AM, Paul Mackerras wrote:
>> + /sys/kernel/debug/powerpc/fadump_region
>> +
>> +    This file shows the reserved memory regions if fadump is
>> +    enabled otherwise this file is empty. The output format
>> +    is:
>> +    <region>: [<start>-<end>] <reserved-size> bytes, Dumped: <dump-size>
>> +
>> +    e.g.
>> +    Contents when fadump is registered during first kernel
>> +
>> +    # cat /sys/kernel/debug/powerpc/fadump_region
>> +    CPU : [0x0000006ffb0000-0x0000006fff001f] 0x40020 bytes, Dumped: 0x0
>> +    HPTE: [0x0000006fff0020-0x0000006fff101f] 0x1000 bytes, Dumped: 0x0
>> +    DUMP: [0x0000006fff1020-0x0000007fff101f] 0x10000000 bytes, Dumped: 0x0
> 
> How come the HPTE region is only 0x1000 (4k) bytes?  The hashed page
> table (HPT) will be much bigger than this.  Is this our way of telling
> the hypervisor that we don't care about the HPT?  If so, is it
> possible to make this region 0 bytes instead of 0x1000?
> 

The firmware assisted dump registration fails with "Hardware
error (-1)" when called with HPTE dump section with size 0.

According to PAPR the size returned by ibm,configure-kernel-dump-sizes
node for HPTE dump section is a minimum size for HPTE dump section.

Though PAPR dose not mention this, but after sevaral trial and error, it
looks like the HPTE dump section is one of the mandatory
argument that needs to be passed (with non-zero size) while making
ibm,configure-kernel-dump rtas call.

Thanks,
-Mahesh.

