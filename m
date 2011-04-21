Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1DUScj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:32:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48954 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751557Ab1DUSci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:32:38 -0400
Date: Thu, 21 Apr 2011 19:32:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Haojian Zhuang <hzhuang1@marvell.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 13/14] regulator: max8925: fix not add device if
	missing init data
Message-ID: <20110421183236.GA31850@opensource.wolfsonmicro.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com> <1303300539-2941-1-git-send-email-haojian.zhuang@marvell.com> <20110421104204.GB11788@opensource.wolfsonmicro.com> <25B60CDC2F704E4E9D88FFD52780CB4C05CF0EF027@SC-VEXCH1.marvell.com> <20110421120327.GD11788@opensource.wolfsonmicro.com> <BANLkTik3w-uv95jHdBt7Q7qU54zc1=gCFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik3w-uv95jHdBt7Q7qU54zc1=gCFA@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 11:23:19PM +0800, Haojian Zhuang wrote:
> On Thu, Apr 21, 2011 at 8:03 PM, Mark Brown

> > What makes you say this?  If you remove the check for the first entry
> > being null then the driver will go and register all the regulators which
> > seems fine.  That seems like it fixes the problem with skipping all the
> > regulators if the first one has no platform data.

> If I keep original method and only fix the null issue on regulator[0], I can
> also register regulators. But it'll display error messages since
> regulator_init_data is null while it's registers.

Registering regulators with null init data seems like a reasonable thing
to want to do - let's just remove the error message.
