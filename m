Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1GXDGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:06:41 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:51455 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab1GXDGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:06:35 -0400
X-AuditID: 12074424-b7b0fae000000a08-33-4e2b8c4bf0bd
Message-ID: <4E2B8C35.7030304@mit.edu>
Date: Sat, 23 Jul 2011 23:06:29 -0400
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsUixG6nruvdo+1n8GG6hcWxZfvZLK4ulrV4
	2vSD3WLL9SYmi8u75rBZ9Dw9zmqxo3c7kwO7R+ulv2we7/ddZfP4vEkugDmKyyYlNSezLLVI
	3y6BK+N17262gs2cFU9PPmNvYDzG3sXIySEhYCKxY/10KFtM4sK99WxdjFwcQgL7GCWO/J8L
	5WxglGhfNIsJwnnLJPFj/iYmkBZeATWJ059mgNksAqoSJ/8sYwSx2QRUJDqWPgCLiwoESdz/
	3cACUS8ocXLmEzBbBKim834XC8hQZoGVjBIL/3YzgySEBaIktpybAFYkJJAvcf/iRqChHByc
	AnYSV7bkgJjMAtYS33YXgVQwC8hLbH87h3kCo+AsJBtmIVTNQlK1gJF5FaNsSm6Vbm5iZk5x
	arJucXJiXl5qka65Xm5miV5qSukmRnDYu6jsYGw+pHSIUYCDUYmHd8MXLT8h1sSy4srcQ4yS
	HExKorxuHdp+QnxJ+SmVGYnFGfFFpTmpxYcYJTiYlUR4L28BKudNSaysSi3Kh0lJc7AoifOW
	ev/3FRJITyxJzU5NLUgtgsnKcHAoSfCGdwMNFSxKTU+tSMvMKUFIM3FwggznARp+DKSGt7gg
	Mbc4Mx0if4pRUUqcdxFIQgAkkVGaB9cLS0uvGMWBXhHm7Qap4gGmNLjuV0CDmYAGyytoggwu
	SURISTUw7tx4+8PSP3fm7ZN8eDy28Nmrq3f3ma2KU63oMbjqUjZPq3+zr8uct4/2vt9qZ++g
	YV1xatXjWcuTOkp3RagHly6yC9pRdstf4aXaFW0+qWShzTOO82gs41lREe5bfEexWqtmY92h
	qFLBNT/E20uP7Q2/qrPdaFqB5olJ6U/2LPXf/u/xBv5pLUosxRmJhlrMRcWJAOAubq0mAwAA
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

How is this different from setting 3400000 vs 3401000 as the max freq? 
(I'm probably missing something about the way that Intel's turbo mode 
works.)

> +static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
> +			 size_t count)
> +{
> +	int ret = -EINVAL;
> +	unsigned long val = 0;
> +
> +	ret = strict_strtoul(buf, 10,&val);
> +	if (!ret&&  (val == 0 || val == 1)&&  cpb_supported)
> +		cpb_toggle(val);

Shouldn't this set the flag only on policy->cpu (as opposed to all 
online cpus?)

Also, you're missing a space before &&.

--Andy
