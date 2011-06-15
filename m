Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1FOOsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:48:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56107 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753026Ab1FOOs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:48:28 -0400
Date: Wed, 15 Jun 2011 15:48:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, grant@secretlab.ca
Subject: Re: [PATCH] FRV: Hook up gpiolib support
Message-ID: <20110615144823.GA2806@opensource.wolfsonmicro.com>
References: <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5194.1308074912@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5194.1308074912@redhat.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 07:08:32PM +0100, David Howells wrote:

> There's an ordering problem.  The #inclusion of asm-generic/gpio.h must come
> both before *and* after the functions in asm/gpio.h.  Take gpio_get_value()
> for instance, it requires __gpio_get_value() - which is defined by the generic
> header - but is used by gpio_get_value_cansleep() in the generic header.

Could you be more specific about the issue you see here?  The arch
header includes the generic header which appears to prototype all the
functions before it uses them.  I do also note that this is a verbatim
copy of the header that's been used on PowerPC for some considerable
time; is this some FRV specific limitation that wouldn't affect other
architectures?

> You must split asm-generic/gpio.h.

I must?
