Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1DUExl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:53:41 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47266 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1DUExh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:53:37 -0400
Message-ID: <4DAFB847.50404@linux.vnet.ibm.com>
Date: Thu, 21 Apr 2011 10:23:27 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-pm] [RFC PATCH V3 4/4] cpuidle: Single/Global registration
 of idle states
References: <20110420065445.332.13688.stgit@tringupt.in.ibm.com> <20110420065608.332.30043.stgit@tringupt.in.ibm.com> <87k4eo6d5m.fsf@ti.com>
In-Reply-To: <87k4eo6d5m.fsf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/20/2011 11:03 PM, Kevin Hilman wrote:
> Trinabh Gupta<trinabh@linux.vnet.ibm.com>  writes:
>
>> With this patch there is single copy of cpuidle_states structure
>> instead of per-cpu. The statistics needed on per-cpu basis
>> by the governor are kept per-cpu. This simplifies the cpuidle
>> subsystem as state registration is done by single cpu only.
>> Having single copy of cpuidle_states saves memory. Rare case
>> of asymmetric C-states can be handled within the cpuidle driverand
>> architectures such as POWER do not have asymmetric C-states.
>
> I haven't actually tested this series on OMAP yet, but it currently
> doesn't compile.

Hi Kevin,

Yes, I tested it only for x86 (as I had mentioned in the description
of the patch series). I just wanted to get comments on the design
and understand how it affects various architectures in question. It
looks to me as if the design should be okay and infact better for
architectures like ARM since they do not have different idle
states for different cpus and thus do not require per-cpu registration.
Global registration would work and be simpler; please correct me if I am
wrong.

>
> The patch below (on top of your series) is required to compile on OMAP,
> I think it's doing what you intended, but please confirm.

Thanks for helping with this.

-Trinabh
