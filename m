Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1CHMlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:41:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33221 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754662Ab1CHMlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:41:53 -0500
Date: Tue, 8 Mar 2011 12:41:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH v2 2/2] MAX8997/8966 PMIC Regulator Driver Initial
 Release
Message-ID: <20110308124151.GD20944@opensource.wolfsonmicro.com>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
 <1299221427-4726-3-git-send-email-myungjoo.ham@samsung.com>
 <20110305120302.GC30187@opensource.wolfsonmicro.com>
 <AANLkTik4cT3fbsCLFcsUcNMtia1Ymnhe8JFzzO+N+9sq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik4cT3fbsCLFcsUcNMtia1Ymnhe8JFzzO+N+9sq@mail.gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:50:04AM +0900, MyungJoo Ham wrote:
> On Sat, Mar 5, 2011 at 9:03 PM, Mark Brown

> > This looks odd, especially since you have a disable operation?

> The intention is to keep it enabled if it was enabled before entering
> sleep and not to enable if it has not been using while the system is
> running. Probably, we need three states for suspend-prepare for
> regulators: disable, enable, keep_state?

No, that's not what the suspend mode settings are doing.  Many
regulators have separate state configuration for use when the system is
suspended, the purpose of suspend_prepare() is to configure that.  They
are orthogonal to the state seen when the system is running and it is
expected that the previously configured state will be automatically
recovered when exiting suspend.

The reason we set this stuff immediately before suspend is that Linux
has multiple suspend types so we need to adjust the configuration to
reflect the suspend type that's been chosen.
