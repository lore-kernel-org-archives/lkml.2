Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2IDJcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:32:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab2IDJcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:32:50 -0400
Date: Tue, 4 Sep 2012 11:32:31 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 -tip 1/5] x86, MSI: Support multiple MSIs in presense
 of IRQ remapping
Message-ID: <20120904093230.GA17873@dhcp-26-207.brq.redhat.com>
References: <cover.1346653435.git.agordeev@redhat.com>
 <034a9cbb168501954408f1004a28c827f3a4158b.1346653435.git.agordeev@redhat.com>
 <CAE9FiQUuAPy884Ytu5PrFkcoQ5tT_DPxyYDk1D1jKbo+G577Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUuAPy884Ytu5PrFkcoQ5tT_DPxyYDk1D1jKbo+G577Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 11:53:39AM -0700, Yinghai Lu wrote:
> On Mon, Sep 3, 2012 at 2:17 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> You may update create_irq_nr to be __create_irq_nr, and it could take
> extra count.
> 
> and later have create_irq_nr to be __create_irq_nr(,1,)
> and create_irqs to be __create_irq_nr(,count,)
> ....

Indeed. Will do.

> BTW, in short, how much performance benefits for adding 500 lines code?

Unfortunatelly, I do not have a short answer here. There are three types
of performance this series deals with - I'll try to summarize:

- devices - 3 SATA HDDs generate roughly one interrupt every 273 us while
  it get handled in less than 5 us. So there is/could be no increase here;

- the hardware context interrupt handler - its performance dropped 2.5 times
  (little bit more in fact) at the expense of increase of 1.3 times in
  overall interrupt handling time (hardware context + threaded context);

- overall system performance - I *assume* it should increase, because:
  (a) AHCI interrupt handlers keep local interrupts disabled 2.5 times less
  (b) separate AHCI IRQs become subjects of IRQ balancing
  (c) threaded handlers are per-device, per-CPU (well, up to irqbalanced)
      and executed with local interrupts enabled;

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
