Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0D0RI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:08:26 -0400
Received: from smtp-out.google.com ([74.125.121.35]:15275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0D0RIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:08:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=IrqLNIayiV938286jcsFFkdxlF8UVqYdl78xZi4lFbXn9KXn39zKjWPIIVoL5Ufr/
	3q7rhNZbI6nWI8H6PRIWg==
MIME-Version: 1.0
In-Reply-To: <1272380262-23671-2-git-send-email-trenn@suse.de>
References: <1272380262-23671-1-git-send-email-trenn@suse.de>
	 <1272380262-23671-2-git-send-email-trenn@suse.de>
Date: Tue, 27 Apr 2010 10:08:17 -0700
Message-ID: <u2n3055132f1004271008m9528841brcbff0aa031a8af43@mail.gmail.com>
Subject: Re: [PATCH 1/2] acpi-cpufreq: Fix CPU_ANY CPUFREQ_{PRE,POST}CHANGE 
	notification
From: Venkatesh Pallipadi <venki@google.com>
To: Thomas Renninger <trenn@suse.de>
Cc: x86@kernel.org, linux-trace-users@vger.kernel.org,
       linux-perf-users@vger.kernel.org, robert.schoene@tu-dresden.de,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
       arjan@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Venkatesh Pallipadi <venki@google.com>

On Tue, Apr 27, 2010 at 7:57 AM, Thomas Renninger <trenn@suse.de> wrote:
>
> This has been found be review.
> Currently PRE/POSTCHANGE events seem to only be thrown for one core
> if the BIOS tells us to run in CPU_ANY mode (switching one/any
> of the depending cores is enough).
>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: venki@google.com
> CC: davej@redhat.com
> CC: linux-kernel@vger.kernel.org
> CC: cpufreq@vger.kernel.org
> CC: linux-perf-users@vger.kernel.org
> CC: linux-trace-users@vger.kernel.org
> CC: x86@kernel.org
> CC: robert.schoene@tu-dresden.de
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 4591680..c6de3a9 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -391,7 +391,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
>
>        freqs.old = perf->states[perf->state].core_frequency * 1000;
>        freqs.new = data->freq_table[next_state].frequency;
> -       for_each_cpu(i, cmd.mask) {
> +       for_each_cpu(i, policy->cpus) {
>                freqs.cpu = i;
>                cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
>        }
> @@ -407,7 +407,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
>                }
>        }
>
> -       for_each_cpu(i, cmd.mask) {
> +       for_each_cpu(i, policy->cpus) {
>                freqs.cpu = i;
>                cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
>        }
> --
> 1.6.3
>
