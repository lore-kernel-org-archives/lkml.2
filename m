Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2ABBaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 20:30:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30539 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2ABBa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 20:30:27 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-f5-4f0108b1d2f6
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
References: <1325112925-9140-1-git-send-email-sbkim73@samsung.com>
 <20111229105729.GF2909@opensource.wolfsonmicro.com>
 <002901ccc6b7$0180e100$0482a300$@com>
 <20111230103725.GB2766@opensource.wolfsonmicro.com>
In-reply-to: <20111230103725.GB2766@opensource.wolfsonmicro.com>
Subject: RE: [PATCH v3 RESEND] regulator: Add S5M8767A regulator driver
Date: Mon, 02 Jan 2012 10:30:31 +0900
Message-id: <006301ccc8ee$1de26650$59a732f0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczG3wiHeTue8F8cSqWLP1lyZDmuSACAwSEw
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On Fri, Dec 30, 2011 at 7:37 PM +0900, Mark Brown wrote:
> > > > +	ret = s5m8767_get_register(rdev, &reg);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	return s5m_reg_update(s5m8767->iodev, reg, ~pattern, mask);
> 
> > > The above looks like it's going to update the same registers as the
> > > regular enable and disable which isn't right, this function is for
> > > updating suspend mode configuration.
> 
> > What's exact meaning of updating suspend mode configuration?
> > As I know, The purpose of set_suspend_enable is that
> > enabling voltage output during suspend mode.
> > So, I implement same register enable and disable.
> 
> If there's only the one set of registers you should just not implement
> this function.  Some regulators have separate registers for configuring
> the state they go into when suspended so they need a separate call to
> configure that mode.
Ok, I will remove another implementation of the same register 
for set_suspend_*.

> > > > +	do {
> > > > +		ret = s5m_reg_read(s5m8767->iodev, reg, &val);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +
> > > > +		s5m_reg_update(s5m8767->iodev, reg,
> > > > +				((val & 0x3f) | 0x40), 0xff);
> > > > +		reg++;
> > > > +		if ((reg == S5M8767_REG_LDO9CTRL) ||
> > > > +			(reg == S5M8767_REG_LDO11CTRL) ||
> > > > +			(reg == S5M8767_REG_LDO13CTRL) ||
> > > > +			(reg == S5M8767_REG_LDO17CTRL))
> > > > +			reg++;
> > > > +	} while (reg <= S5M8767_REG_LDO16CTRL);
> 
> > > What does this do?
> 
> > This is SMDK4412 specific code.
> > I will delete it for the general purpose.
> 
> OK.  Is it something that's missing from the framework or was it just
> done this way for a quick test?
S5M8767A has various power mode.
Especially, It can synchronize with AP power mode.
This initialization code is related to AP synchronization.
I have plan to add regulator framework for this function.
After merging basic S5M8767A driver, I will submit regulator framework.

Thanks,
Happy new year!

Sangbeom.

