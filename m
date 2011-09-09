Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab1IIQOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:14:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42662 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759349Ab1IIQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:14:22 -0400
Date: Fri, 9 Sep 2011 09:14:19 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Support half writes and padding between
 register and value.
Message-ID: <20110909161418.GB3515@opensource.wolfsonmicro.com>
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
 <1315490964-25718-2-git-send-email-jic23@cam.ac.uk>
 <20110908162715.GB3098@opensource.wolfsonmicro.com>
 <4E69E019.6060601@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E69E019.6060601@cam.ac.uk>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:44:57AM +0100, Jonathan Cameron wrote:
> On 09/08/11 17:27, Mark Brown wrote:

> > Please do a patch adding padding separately - that does seem like a
> > useful thing to have in general, with the option of having it both
> > before and after the register.

> Happy to do it separately, but not sure the padding before the register
> address is a real use case.  You pad after to give the device time to
> respond, before doesn't make much sense to me on a register based device...
> I'll change the naming to make it explicit that it is after the register though
> so as to leave room for this to be added in future.

Some devices apparently use an entire byte or word with a magic flag in
it to distinguish reads and writes.  These end up looking like 16 bit
registers with only the lower 8 bits actually used in the current code.
