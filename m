Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab2HXC5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2HXC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:57:41 -0400
Message-ID: <5036ED97.8040306@redhat.com>
Date: Thu, 23 Aug 2012 22:57:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ShuoX Liu <shuox.liu@intel.com>, mjg59@srcf.ucam.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/3] c-state governor changes
References: <20120823171104.38574add@cuia.bos.redhat.com> <5036A67D.9090904@linux.intel.com>
In-Reply-To: <5036A67D.9090904@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 05:54 PM, Arjan van de Ven wrote:
> On 8/23/2012 2:11 PM, Rik van Riel wrote:
>> This patch set is mostly there to kick off a discussion in time
>> for Kernel Summit.  When running it on my laptop, with acpi_idle,
>> I see a promising change in powertop.
>
> be careful with acpi_idle... that will remove most of the intermediate C states the platform has,
> so the policy engine no longer has good things to chose from.

Interesting, I was not aware of that.

Another thing I did see is that the intel_idle driver selects
a target residency time around 4x larger than the exit latency
for most c-states, while acpi_idle sticks to 2x by default.

Aiming for a residency time only 2x the exit latency seems
excessively aggressive, especially for the deeper c states.

The latency issues with various KVM guests communicating with
each other have been observed on various Intel and AMD chipsets,
not unique to one vendor.

-- 
All rights reversed
