Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1GDXtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:49:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25992 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1GDXtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:49:16 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-ef-4e12517bec49
Date: Tue, 05 Jul 2011 08:49:14 +0900
From: Sangbeom Kim <sbkim73@samsung.com>
Subject: RE: [PATCH 2/3] mfd: Add initial S5M8751 support
In-reply-to: <20110704140731.GC3021@sortiz-mobl>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <035b01cc3aa4$fb4fa490$f1eeedb0$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acw6U6dGHHATBfyZSICUPvq2RUzXmQATR8iA
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-3-git-send-email-sbkim73@samsung.com>
 <20110704140731.GC3021@sortiz-mobl>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for your kindly comment.

On Monday, July 04, 2011 11:08 PM +0900, Samuel Ortiz wrote:
> On Wed, Jun 22, 2011 at 02:53:56PM +0900, Sangbeom Kim wrote:
> > +#define SLEEPB_ENABLE		1
> > +#define SLEEPB_DISABLE		0
> > +
> > +static DEFINE_MUTEX(io_mutex);
> I would prefer to see your IO mutex defined from your s5m8751 structure.

Ok, I will make IO mutex in s5m8751 structure in the next version.
> 
> > +int s5m8751_clear_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t
> mask)
> > +{
> > +	uint8_t reg_val;
> > +	int ret = 0;
> > +
> > +	ret = s5m8751_reg_read(s5m8751, reg, &reg_val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	reg_val &= ~mask;
> > +	ret = s5m8751_reg_write(s5m8751, reg, reg_val);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(s5m8751_clear_bits);
> > +
> > +int s5m8751_set_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t
mask)
> > +{
> > +	uint8_t reg_val;
> > +	int ret = 0;
> > +
> > +	ret = s5m8751_reg_read(s5m8751, reg, &reg_val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	reg_val |= mask;
> > +	ret = s5m8751_reg_write(s5m8751, reg, reg_val);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(s5m8751_set_bits);
> Your locking for both of those routines is also racy. There's nothing
> preventing a writre to happen between your read and your write. They need
> to
> happen atomically, and for that you need to take the lonk in the clear/set
> bits routine.
Ok, I will add mutex_lock between read and write in the next version.
Sooner or later, I will submit new patches.

Thanks,
SB Kim

