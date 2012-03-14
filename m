Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2CNVMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:12:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48660 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2CNVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:12:08 -0400
MIME-Version: 1.0
In-Reply-To: <1331647629-11550-1-git-send-email-jiang.liu@huawei.com>
References: <1331647629-11550-1-git-send-email-jiang.liu@huawei.com>
Date: Wed, 14 Mar 2012 14:12:06 -0700
Message-ID: <CA+8MBbLsA8OysJNFMN4a0p6Yj3qmmawvtE0pGtcnAJpULjNi+A@mail.gmail.com>
Subject: Re: [PATCH] IA64: fix ISA IRQ trigger model and polarity setting
From: Tony Luck <tony.luck@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Liu Jiang <jiang.liu@huawei.com>, linux-ia64@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>, chenkeping@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When handling Interrupt Source Override in MADT table, the default
> ISA IRQ trigger model and poliarity should be edge-rising.
> Current IA64 implmentation doesn't follow the specification and
> set default ISA IRQ trigger model as level-low. With that wrong
> configuration and when system runs out of interrupt vectors,
> it will cause vector sharing among edge triggered ISA IRQ and
> level triggered PCI IRQ, then interrupt storm. So change the code
> to follow the specification.

I chased the reference in ACPI to the MPS spec:
 http://www.intel.com/design/pentium/datashts/24201606.pdf

Which says in table 4-10 "for example. EISA is active-low for
level triggered interrupt" and "for example, EISA is edge-triggered".

It looks to me that if MADT says "high", we should set high, if it says
"low" we should set low. Ditto for trigger vs. level. But if we see the
value "0" - then we have more work to do to determine what the
bus we are on uses for its default.

Did you find some other specification that gives a better explanation?
Or did I miss something - can we only get to this routine for ISA?

You've tested this patch - and it works for you - but is there a risk
that it will break someone else?

-Tony
