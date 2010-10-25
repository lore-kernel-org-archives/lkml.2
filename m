Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab0JYRz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:55:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60060 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754127Ab0JYRz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:55:28 -0400
Date: Mon, 25 Oct 2010 10:55:36 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] regulator: max8952 - fix max8952_set_voltage
Message-ID: <20101025175535.GC16246@opensource.wolfsonmicro.com>
References: <1287972667.23608.2.camel@mola>
 <1287973026.23608.6.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287973026.23608.6.camel@mola>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 10:17:06AM +0800, Axel Lin wrote:
> In current implementation, vid is declared as u8,
> then "vid == -1" is always false, and "vid >= 0" is always true.
> Thus change it to s8.
> 
> vid is always less than MAX8952_NUM_DVS_MODE in current implementation,
> thus remove the cheking for "vid < MAX8952_NUM_DVS_MODE".

This bit seems like reasonable paranoia in the face of future code
changes and we're not really in a sufficiently fast path to worry about
cycles - are you sure that this is essential?
