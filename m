Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1JQKUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:20:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53494 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab1JQKUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 06:20:02 -0400
Date: Mon, 17 Oct 2011 11:19:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111017101959.GC3042@opensource.wolfsonmicro.com>
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
 <1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
 <20111013143224.GO1098@sirena.org.uk>
 <4E96F9AC.9000001@cam.ac.uk>
 <20111013204410.GA17160@sirena.org.uk>
 <4E985C60.9020308@cam.ac.uk>
 <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
 <4E9BF8D9.8030301@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9BF8D9.8030301@cam.ac.uk>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 10:43:53AM +0100, Jonathan Cameron wrote:

> For the adc channel I'm not particularly keen on insisting every device
> have a unique name for every channel.  That breaks the effort we went to
> in IIO to enforce consistent naming (for userspace interfaces) in the first
> place.  To my mind it should never be anything other than a number.

I think you want something similar to what we do with platform devices -
have both a name and a number.  For devices that are just a bunch of
symmetric channels (which seems to be the main case you're thinking of)
the name would always be the same and the number would vary but if the
device has a bunch of different functions then they'd be named.  That
way you don't have to remember that the channels of a given type start
at offset X.

For example, on a PMIC you'll often have ADC channels wired up to
specific supplies plus some extras which are left for board use.  The
fixed channels might get named after the supplies and the extras all
have the same name distinguished by number.
