Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab2BMXai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:30:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51864 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2BMXag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:30:36 -0500
Message-ID: <4F399D19.9090904@kernel.org>
Date: Mon, 13 Feb 2012 18:30:33 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] ACPI: Do cpufreq clamping for throttling per package
 v2
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org> <1328545032-21373-5-git-send-email-andi@firstfloor.org> <20120206163106.GB32061@srcf.ucam.org>
In-Reply-To: <20120206163106.GB32061@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 11:31 AM, Matthew Garrett wrote:

> On Mon, Feb 06, 2012 at 08:17:11AM -0800, Andi Kleen wrote:
>> +#define reduction_pctg(cpu) \
>> +	per_cpu(cpufreq_thermal_reduction_pctg, phys_package_first_cpu(cpu))
> 
> I don't like using percentages here - we end up with the potential for 
> several percentages to end up mapping to the same P state.


Does it matter?

> I've sent a

> patch that replaces the percentage code with just stepping through P 
> states instead. But otherwise, yes, this seems sensible. An open 
> question is whether we should be doing the same on _PPC notifications. 
> There's some vague evidence that Windows does.

If you stepped by P-states, then you behave entirely differently
on a machine with many P-states vs a machine with few P-states.

There is code floating about that exposes every 100 MHz step on SNB
and later as a P-state -- you can have quite a few...

thanks,
-Len Brown, Intel Open Source Technology Center


