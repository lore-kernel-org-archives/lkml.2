Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab2GKPOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:14:32 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:64237 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab2GKPOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:14:31 -0400
Message-Id: <201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
CC: Liam Girdwood <lrg@ti.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Fix bug in regulator_mode_to_status() core function.
References: <20120711142606.GK3938@opensource.wolfsonmicro.com>
	<201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
	<20120711132655.GG3938@opensource.wolfsonmicro.com>
	<201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
In-Reply-To: <20120711142606.GK3938@opensource.wolfsonmicro.com>
Date: Wed, 11 Jul 2012 16:13:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This is deliberate.  It's not reporting an error, it's reporting an
> > > indeterminate status which is a different thing.
> 
> > Ok, then I would propose to use REGULATOR_STATUS_OFF instead of 0, to present
> > your deliberate decision here.
> 
> I don't think you're fully understanding "indeterminate" there...  the
> whole point is that we can't adequately represent the state, making
> something up isn't helping things.

Would it make more sense to have some special enum value for that case, let say
there would be REGULATOR_STATUS_UNDEFINED?

Returning 0 is interpreted as REGULATOR_STATUS_OFF outside the function.
But it may change, if ever the enumeration changes.

