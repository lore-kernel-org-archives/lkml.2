Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1GXDPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:15:10 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:45742 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab1GXDPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:15:06 -0400
X-AuditID: 1209190c-b7bdeae000000a26-14-4e2b8dd10c25
Message-ID: <4E2B8E36.6030308@mit.edu>
Date: Sat, 23 Jul 2011 23:15:02 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: cpufreq@vger.kernel.org, davej@redhat.com, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com, mark.langsdorf@amd.com,
        andreas.herrmann3@amd.com
Subject: Re: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic
 overclocking
References: <1311007062-2050-1-git-send-email-mjg@redhat.com> <1311007062-2050-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1311007062-2050-4-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsUixCmqrXuxV9vP4NlfA4tjy/azWVxdLGvx
	tOkHu8WW601MFpd3zWGz6Hl6nNViR+92Jgd2j9ZLf9k83u+7yubxeZNcAHMUl01Kak5mWWqR
	vl0CV8bumcdYCs5zVTx+18ncwHiRo4uRk0NCwETi44xPbBC2mMSFe+uBbC4OIYF9jBJNz16x
	QzgbGCWWrf7MBOG8ZZKYcm4vK0gLr4CaxIxnx9hBbBYBVYmTf7aA2WwCKhIdSx8wgdiiAkES
	9383sEDUC0qcnPkEzBYBqum838UCMpRZYCWjxMK/3cwgCWGBKIkt5yaAFQkJ5Evcv7iRsYuR
	g4NTwE7iypYcEJNZwFri2+4ikApmAXmJ7W/nME9gFJyFZMMshKpZSKoWMDKvYpRNya3SzU3M
	zClOTdYtTk7My0st0jXUy80s0UtNKd3ECA57SZ4djG8OKh1iFOBgVOLh3fhFy0+INbGsuDL3
	EKMkB5OSKO+nHm0/Ib6k/JTKjMTijPii0pzU4kOMEhzMSiK8l7cAlfOmJFZWpRblw6SkOViU
	xHnLvf/7CgmkJ5akZqemFqQWwWRlODiUJHjXA+NbSLAoNT21Ii0zpwQhzcTBCTKcB2j4KpAa
	3uKCxNzizHSI/ClGRSlx3l0gCQGQREZpHlwvLC29YhQHekWYNxukigeY0uC6XwENZgIaLK+g
	CTK4JBEhJdXAKPryd4DOIXuzp/GVzWuK2KM6L3xearLx04elcz/9n6t5T8rg1rzpCrNTNIqM
	hSxPLfq8xXV98B/G2UW1H2bfOcDNue/mlJVirQvEfHK1d975uyFia7rnK+2bC2psuNicprya
	5MWY5B17ozeYW9yymqvASX159dXk5q8fHtZIp4iEsEj4/j/nosRSnJFoqMVcVJwIAB9XYugm
	AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2011 12:37 PM, Matthew Garrett wrote:
> One feature present in powernow-k8 that isn't present in acpi-cpufreq is
> support for enabling or disabling AMD's core performance boost technology.
> This patch adds that support to acpi-cpufreq, but also extends it to allow
> Intel's dynamic acceleration to be disabled via the same interface. The
> sysfs entry retains the cpb name for compatibility purposes.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> ---
>   drivers/cpufreq/acpi-cpufreq.c |  191 ++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 191 insertions(+), 0 deletions(-)
>

> +			if (enable)
> +				reg->q&= ~MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
> +			else
> +				reg->q |= MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
> +		}

I was curious and looked it up.  Intel SDM volume 3, 14.3.2.1 says:

Opportunistic processor performance operation can be disabled by setting 
bit 38 of
IA32_MISC_ENABLE. This mechanism is intended for BIOS only. If
IA32_MISC_ENABLE[38] is set, CPUID.06H:EAX[1] will return 0.

and the next section says:

System software can temporarily disengage opportunistic processor 
performance
operation by setting bit 32 of the IA32_PERF_CTL MSR (0199H), using a read-
modify-write sequence on the MSR.

Would that be a better way to control boost mode on Intel chips?

--Andy
