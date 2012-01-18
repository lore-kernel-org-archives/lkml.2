Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2ARR4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:56:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52895 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab2ARR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:56:16 -0500
Date: Wed, 18 Jan 2012 17:56:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Message-ID: <20120118175613.GT8732@opensource.wolfsonmicro.com>
References: <1326899836-14470-1-git-send-email-ldewangan@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE10@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE10@HQMAIL01.nvidia.com>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 09:54:27AM -0800, Stephen Warren wrote:
> Laxman Dewangan wrote at Wednesday, January 18, 2012 8:17 AM:

> > +		.table_len = 73,
> >  	},

> Forgive me if these comments are bogus since I'm not familiar with
> regulators much, but:

> a) Don't you want to use ARRAY_SIZE() instead of hard-coding table_len's
> value?

> b) Don't you need to set .table to actually point at the table too? If not,
> isn't tps65910_list_voltage() going to dereference a NULL pointer, since
> it will dereference .table if .table_len is set?

It's not actually a table at all any more as the driver calculates the
values, table_len is misnamed and should be renamed as well as set.
