Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1FFL3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:29:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33020 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1FFL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:29:37 -0400
Message-ID: <4DECBA16.7070300@in.ibm.com>
Date: Mon, 06 Jun 2011 16:59:26 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Simon Horman <horms@verge.net.au>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kexec@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] powerpc: Use the #address-cells information to parsememory/reg
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AD73@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AD73@saturn3.aculab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/11 14:30, David Laight wrote:
>>> Changed the add_usable_mem_property() to accept FILE* fp instead of
> int fd,
>>> as most of the other users of read_memory_region_limits() deals with
> FILE*.
>>>
>>> Signed-off-by: Suzuki K. Poulose<suzuki@in.ibm.com>
>>
>> Could you please let me know your thoughts/comments about this patch ?
>
> Is the change to use 'FILE *' actually progress?
> I'd have thought that the randomly aligned read/lseek system calls
> that this allows to happen are not desirable for anything that
> isn't a true file.
I will revert the other users back to 'fd'
>
> I'd also suggest that the sizeof's should be applied to the
> actual type of the variable being read/written, not arbitrarily
> 'long' or 'int', and this probably ought to be some fixed size type.
I have used 'unsigned long'(for word sized values) or 'unsigned long long'
(for double words) just to make sure we get the right values. Is this OK ?

Thanks
Suzuki
