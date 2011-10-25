Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1JYIgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:36:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52049 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057Ab1JYIgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:36:36 -0400
Date: Tue, 25 Oct 2011 10:36:34 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, dmitry.torokhov@gmail.com,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, aghayal@codeaurora.org,
        david@hardeman.nu, Shubhrajyoti@ti.com, saaguirre@ti.com,
        hemanthv@ti.com, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 4/6] input/cma3000_d0x: Add CMA3000 spi support
Message-ID: <20111025083633.GB31508@opensource.wolfsonmicro.com>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
 <1319487676-27181-5-git-send-email-ricardo.ribalda@gmail.com>
 <20111024213635.GB4394@ponder.secretlab.ca>
 <CAPybu_3pF6u10JMmcbho1e7=8EPHMq8LQ1+uHpyVMOmbRMUsHA@mail.gmail.com>
 <4EA6741B.6090508@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA6741B.6090508@cam.ac.uk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 09:32:27AM +0100, Jonathan Cameron wrote:
> On 10/25/11 08:24, Ricardo Ribalda Delgado wrote:

> > It is not on linux-next, and also it cannot be used directly, in order
> > to read you have to do set reg= (reg << 2) | 2; And AFAIK it is not
> > supported by the regmap

> My gut feeling is it would easy enough to add if it can't currently
> be done. Mark?

That should be trivial to add - the | 2 bit is already supported in
-next and will be sent to Linus this merge window, adding the shift is
just a simple matter of programming.

> Gains here are leveraging the bus abstractions from there.  There aren't
> enough registers to gain from caching etc.

Depends on the workload more than the number of registers - if you're
able to eliminate enough reads then it can give a bit of a performance
boost.  But it's completely optional either way.
