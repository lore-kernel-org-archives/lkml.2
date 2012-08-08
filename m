Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520Ab2HHR5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:57:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51530 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030483Ab2HHR5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:57:07 -0400
MIME-Version: 1.0
In-Reply-To: <1344432423-26495-1-git-send-email-seth.forshee@canonical.com>
References: <CAE9FiQVEsPisVUKeG0aejKzvS+Csp5Ca2KEQyy6ZJW-MR-VFUA@mail.gmail.com>
	<1344432423-26495-1-git-send-email-seth.forshee@canonical.com>
Date: Wed, 8 Aug 2012 10:57:06 -0700
X-Google-Sender-Auth: 3Pt9o2ndbyDQvLZ2T7V-2uxphf8
Message-ID: <CAE9FiQXv7oZX=ANOEBFm7gHP2Ktvkatn+fcrjq99Pu36k-xPWA@mail.gmail.com>
Subject: Re: [PATCH v3] irq_remap: disable IRQ remapping if any IOAPIC lacks
 an IOMMU
From: Yinghai Lu <yinghai@kernel.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 6:27 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> The ACPI tables in the Macbook Air 5,1 define a single IOAPIC with id 2,
> but the only remapping unit described in the DMAR table matches id 0.
> Interrupt remapping fails as a result, and the kernel panics with the
> message "timer doesn't work through Interrupt-remapped IO-APIC."
>
> To fix this, check each IOAPIC for a corresponding IOMMU. If an IOMMU is
> not found, do not allow IRQ remapping to be enabled.
>
> v2: Move check to parse_ioapics_under_ir(), raise log level to KERN_ERR,
>     and add FW_BUG to the log message
> v3: Skip check if IOMMU doesn't support interrupt remapping and remove
>     existing check that the IOMMU count equals the IOAPIC count
>

Acked-by: Yinghai Lu <yinghai@kernel.org>
