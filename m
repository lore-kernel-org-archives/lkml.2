Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1HJQ7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:59:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61218 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1HJQ7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:59:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=wSbi0ZjCYX4+xjU3gSV/7csohm983glyIkEisnVWZjfF4AbWGzg8QjzEj81lZlU5l
	Y6twRw/I2hXorFqjmbj0Q==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1108011033540.23581@x980>
References: <CAC4B8726E86A142B27A9E9A2F2F12470191AAD4C3@rrsmsx505.amr.corp.intel.com>
	<CABeCy1Zvt2rv6r5ea2Pum+2gCDYJS-A3-00_0U2+ZcWV_kip4A@mail.gmail.com>
	<CAC4B8726E86A142B27A9E9A2F2F124701921EF878@rrsmsx505.amr.corp.intel.com>
	<alpine.LFD.2.02.1108011033540.23581@x980>
Date: Wed, 10 Aug 2011 09:59:33 -0700
Message-ID: <CABeCy1aGhb4BizXwWFyUt8eX+VWMTbjoC22ogymxsY4CPgfZmw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] ondemand governor: dynamic cpufreq scaling with
 different CPUs
From: Venki Pallipadi <venki@google.com>
To: Len Brown <lenb@kernel.org>
Cc: "Yung, Winson W" <winson.w.yung@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Kanigeri, Hari K" <hari.k.kanigeri@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 7:51 AM, Len Brown <lenb@kernel.org> wrote:
> Re: software vs hardware coordination
>
> Speaking for Intel, everything we make, from hand-sets to supercomputers
> supports hardware coorination.
>
> Think about it -- if we did not, then we would not be able
> to support a legacy OS that doesn't know how to do SW coordination.
>
> HW coordiation is the simplest thing for the SW because
> SW doesn't have to know anything at all about topology constraints.
> It is also the simplest thing for the BIOS, which doesn't have
> to correctly describe topology.
>
> Yes, there is an MSR bit that the BIOS can flip to disable
> HW coordination.  90% of the time that bit is set it is a BIOS bug.
> eg. the bit is set, but the BIOS fails to properly set up the
> ACPI tables to properly enable SW coordination, resulting
> in a system with really strange performance issues.
>
> Indeed, I proposed before, and I will propose again that
> the underlying ACPI _PSD support behind SW coordination
> be completely removed from Linux.
>
> Venki,
> I recall that you mentioned one platform that depends on it --
> and I'd  like to understand that issue and address it with a quirk
> rather than expose all systems to BIOS bugs due to bogus _PSD support.
>

Agree. Addressing this as a quirk would be fine. The processor that
needs it is E74xx series, IIRC.

Thanks,
Venki

> Winston,
> Your system is running in SW coordination mode?
> What do you see if you run with the patch below?
> I'd be intersted to see the output from adpidump for your system.
>
> thanks,
> -Len Brown
> Intel Open Source Technology Center
>
> ---
> diff --git a/include/acpi/pdc_intel.h b/include/acpi/pdc_intel.h
> index 552637b..d081595 100644
> --- a/include/acpi/pdc_intel.h
> +++ b/include/acpi/pdc_intel.h
> @@ -22,7 +22,6 @@
>
>  #define ACPI_PDC_EST_CAPABILITY_SWSMP  (ACPI_PDC_SMP_C1PT | \
>                                         ACPI_PDC_C_C1_HALT | \
> -                                        ACPI_PDC_SMP_P_SWCOORD | \
>                                         ACPI_PDC_SMP_P_HWCOORD | \
>                                         ACPI_PDC_P_FFH)
>
>
