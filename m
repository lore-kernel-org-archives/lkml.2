Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab0FVPQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:16:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab0FVPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:16:04 -0400
Message-ID: <4C20D3A3.9010709@zytor.com>
Date: Tue, 22 Jun 2010 08:15:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: borislav.petkov@amd.com, x86@kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: intel_cacheinfo: potential NULL dereference?
References: <4C209C15.9090604@gmail.com> <4C209C6E.3060302@gmail.com>
In-Reply-To: <4C209C6E.3060302@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 04:20 AM, Jiri Slaby wrote:
> On 06/22/2010 01:18 PM, Jiri Slaby wrote:
>> Hi,
>>
>> commit 9350f982 changed the code so it looks like:
>> static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
>>                                    const char *buf, size_t count,
>>                                    unsigned int slot)
>> {
>>         struct pci_dev *dev = this_leaf->l3->dev;   <<1>>
>>         int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
>>         unsigned long val = 0;
>>
>> #define SUBCACHE_MASK   (3UL << 20)
>> #define SUBCACHE_INDEX  0xfff
>>
>>         if (!this_leaf->l3 || !this_leaf->l3->can_disable)  <<2>>
>>                 return -EINVAL;
>>
>> Stanse found, that this_leaf->l3 is dereferenced at <<1>>, but checked
>> for being NULL at <<2>>. Is the check superfluous or the dev assignment
>> should go after the check?
> 
> Oh, and I have another report with same symptoms for show_cache_disable.
> 

Looks broken to me, indeed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

