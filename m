Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2HGROl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:14:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39767 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933Ab2HGROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:14:40 -0400
Date: Tue, 7 Aug 2012 18:14:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NEW DRIVER V1 5/7] DA9058 GPIO driver
Message-ID: <20120807171437.GC16861@opensource.wolfsonmicro.com>
References: <201208020849.q728nhU3007824@latitude.olech.com>
 <20120802101952.GG29157@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C39DE@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032C39DE@NB-EX-MBX02.diasemi.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:15:17PM +0000, Opensource [Anthony Olech] wrote:

> I do realize that REGMAP does locking on individual register accesses,
> however, the each GPIO line is controlled by 4-bits in a register, with
> the meaning of the most significant bit depending on the GPIO direction,
> so it is essential that the register be read first before do an update, thus
> two sequential register accesses must be protected by a mutex to
> prevent another process changing the register (and hence the meaning
> of the most-significant bit) in the middle of the two accesses.

> I hope this explains to your satisfaction why a driver mutex is required
> in addition to the regmap's register access mutex

This seems a bit excessive and complicated - I'd be inclined to either
just say that the caller is responsible for avoiding confusion here
(obviously if you're changing the direction there's a race anyway) or
store the data in a variable locally rather than having to do I/O on the
device under lock every time it's interacted with.
