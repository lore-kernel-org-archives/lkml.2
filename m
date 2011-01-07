Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1AGAcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:32:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64390 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1AGAcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:32:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tx3rOMN4KzBEPdWfqAe9kChExA4ezA2itMkd5AOkl5HnzoRwpb1NWmRs69DU2n4zLu
         I9scDOo4QTOZpX9fb6H5J+oCS9RUOwk3UXo1wPbcHD+pb9NZYzjCNC7a1aUZJuyv6ME8
         PrISsaO64GRVGOCXNjOQha/9KWnwJQb4rZkms=
MIME-Version: 1.0
In-Reply-To: <AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
References: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
	<4d2654c410489a1b90@agluck-desktop.sc.intel.com>
	<AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com>
	<AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
Date: Thu, 6 Jan 2011 16:32:42 -0800
X-Google-Sender-Auth: mK3hVBHNgo2O9yOk4SAqKzcHy4g
Message-ID: <AANLkTi=YCJ+=94hBZT4qnS=Q_BnVXFUo-Fr8dCbPUXbk@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
From: Tony Luck <tony.luck@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 4:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> looks ia64 is using struct array with cpu idx for mapping
>
>        node_cpuid[srat_num_cpus].phys_id =
>            (pa->apic_id << 8) | (pa->local_sapic_eid);
>        /* nid should be overridden as logical node id later */
>        node_cpuid[srat_num_cpus].nid = pxm;
>        cpu_set(srat_num_cpus, early_cpu_possible_map);
>        srat_num_cpus++;

Good point.

> +       if (srat_num_cpus >= NR_CPUS) {
> +               printk(KERN_WARNING "NR_CPUS (%d) is too small, not all cpus used.
> %d\n", NR_CPUS);
> +               return;
> +       }
> +

Looks ok - but printk_once() might be better so we don't flood the console
if someone tries running an NR_CPUS=16 kernel on a monster SGI machine.

-Tony
