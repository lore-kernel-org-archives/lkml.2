Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1L3Kha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 05:37:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38264 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005Ab1L3Kh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 05:37:28 -0500
Date: Fri, 30 Dec 2011 10:37:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 RESEND] regulator: Add S5M8767A regulator driver
Message-ID: <20111230103725.GB2766@opensource.wolfsonmicro.com>
References: <1325112925-9140-1-git-send-email-sbkim73@samsung.com>
 <20111229105729.GF2909@opensource.wolfsonmicro.com>
 <002901ccc6b7$0180e100$0482a300$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002901ccc6b7$0180e100$0482a300$@com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 02:50:59PM +0900, Sangbeom Kim wrote:
> On Thu, Dec 29, 2011 at 07:58 PM, Mark Brown wrote:

> > > +	ret = s5m8767_get_register(rdev, &reg);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return s5m_reg_update(s5m8767->iodev, reg, ~pattern, mask);

> > The above looks like it's going to update the same registers as the
> > regular enable and disable which isn't right, this function is for
> > updating suspend mode configuration.

> What's exact meaning of updating suspend mode configuration?
> As I know, The purpose of set_suspend_enable is that
> enabling voltage output during suspend mode.
> So, I implement same register enable and disable.

If there's only the one set of registers you should just not implement
this function.  Some regulators have separate registers for configuring
the state they go into when suspended so they need a separate call to
configure that mode.

> > > +	do {
> > > +		ret = s5m_reg_read(s5m8767->iodev, reg, &val);
> > > +		if (ret)
> > > +			return ret;
> > > +
> > > +		s5m_reg_update(s5m8767->iodev, reg,
> > > +				((val & 0x3f) | 0x40), 0xff);
> > > +		reg++;
> > > +		if ((reg == S5M8767_REG_LDO9CTRL) ||
> > > +			(reg == S5M8767_REG_LDO11CTRL) ||
> > > +			(reg == S5M8767_REG_LDO13CTRL) ||
> > > +			(reg == S5M8767_REG_LDO17CTRL))
> > > +			reg++;
> > > +	} while (reg <= S5M8767_REG_LDO16CTRL);

> > What does this do?

> This is SMDK4412 specific code.
> I will delete it for the general purpose.

OK.  Is it something that's missing from the framework or was it just
done this way for a quick test?
