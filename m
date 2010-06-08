Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0FHAAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:00:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:50582 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0FHAAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:00:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,380,1272870000"; 
   d="scan'208";a="574191258"
Date: Mon, 7 Jun 2010 17:01:15 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100607170115.00004c4c@unknown>
In-Reply-To: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob Pan Mon,  7 Jun 2010 16:07:24 -0700
>SFI based platforms should have zero based gsi_base for IOAPICs found in SFI
>tables. The current code sets gsi_base starting from 1 when registering ioapic.
>The result is that Moorestown platform would have wrong mp_gsi_routing for each
>ioapic.
>
>Background:
>In Moorestown/Medfield platforms, there is no legacy IRQs, all gsis and irqs
>are one to one mapped, including those < 16. Specifically, IRQ0 and IRQ1 are
>used for per-cpu timers. So without this patch, IOAPIC pin to IRQ mapping is
>off by one.
>
Clarifiction/correction about IRQ0,1. I refer to IOAPIC IRQ #, which is the
IOAPIC RTE entry #. Not in the sense of kernel IRQ# which can be assigned
differently on Moorestown.
