Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1LZMJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 07:09:02 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38204 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab1LZMI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 07:08:59 -0500
Date: Mon, 26 Dec 2011 12:08:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] drivers/mfd/88pm860x-i2c.c: introduce missing kfree
Message-ID: <20111226120855.GB17760@sirena.org.uk>
References: <1324661974-17281-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324661974-17281-1-git-send-email-julia@diku.dk>
X-Cookie: Not every question deserves an answer.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 06:39:26PM +0100, Julia Lawall wrote:
> Error handling code following a kzalloc should free the allocated data.  At
> this point, chip has been allocated and some fields have been initialized,
> but it has not been stored anywhere, so it should be freed before leaving
> the function.

With this and probably a bunch of the other corrections in this series a
conversion to devm_kazlloc() would be a more complete fix as it prevents
people introducing similar missing cleanup paths in future.  Not sure if
spatch can generate that automatically though...
