Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2H3MKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:10:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36338 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2H3MKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:10:33 -0400
Date: Thu, 30 Aug 2012 05:07:48 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 4/8] lp8727_charger: cleanup the interrupt handler code
Message-ID: <20120830120747.GA11289@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F41EF1CA4@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF1CA4@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:39:57AM +0000, Kim, Milo wrote:
> (a) add configurable debounce timer in the platform data
>     : if it is not defined, default time(270ms) is set.
> (b) use schedule_delay_work() and remove unnecessary workqueue resource
>     : for delayed interrupt handling, use the schedule_delay_work()
> (c) add lp8727_release_irq() for clearing the irq
> (c) clear interrupts while loading the driver

It seems to me that all of the issues desire their own separate
patches. A few benefits for this:

- It helps reviewing changes;
- In case of regressions, that would help bisecting a lot, plus we will
  not need to revert the whole thing, if we'd have to fall back to
  revert.

Thanks,
Anton.
