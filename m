Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1HWPlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:41:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46525 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1HWPlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:41:06 -0400
Date: Tue, 23 Aug 2011 16:40:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Wei Ni <wni@nvidia.com>, Samuel Ortiz <sameo@linux.intel.com>,
        "mike@compulab.co.il" <mike@compulab.co.il>,
        Nitin Kumbhar <nkumbhar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: tps6586x: add api to power off tps6586x
Message-ID: <20110823154056.GB26317@sirena.org.uk>
References: <1311834636-15940-1-git-send-email-wni@nvidia.com>
 <20110821230511.GA4607@sortiz-mobl>
 <6B4D417B830BC44B8026029FD256F7F1C2CD7600DD@HKMAIL01.nvidia.com>
 <CAN1soZzkmP=ckzAOJv59YfYtFU63nC9j-Oa+cM5z674yf0Mihw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZzkmP=ckzAOJv59YfYtFU63nC9j-Oa+cM5z674yf0Mihw@mail.gmail.com>
X-Cookie: divorce, n:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 01:06:02PM +0800, Haojian Zhuang wrote:

> Maybe we can add a LDO mapping in regulator driver. Since power-off
> function is always
> customized in board file. We can disable this regulator while
> power_off() is called. So even
> multiple PMICs is installed in one system, we only handle the real one
> to shutdown the
> whole system.

Some (ST?) platform had an issue like that.  What they did IIRC is
define a regulator consumer driver which is hooked up as normal then had
that driver implemented a power_off() which used regulator_disable() to do
the honours.  Perhaps this could be made more generic somehow?  Though
it may have been part of their cpufreq driver or something - I can't
remember the detail right now.
