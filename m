Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0IHSbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:31:37 -0400
Received: from imr4.ericy.com ([198.24.6.8]:60833 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0IHSbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:31:32 -0400
Date: Wed, 8 Sep 2010 11:30:19 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Add support for max6695 and max6696 to lm90
 driver
Message-ID: <20100908183019.GA12314@ericsson.com>
References: <1283639675-31714-1-git-send-email-guenter.roeck@ericsson.com>
 <20100906181229.2e25db07@hyperion.delvare>
 <20100908102816.GA10676@ericsson.com>
 <20100908134854.2c60f406@hyperion.delvare>
 <20100908135654.GA11277@ericsson.com>
 <20100908172902.6ed57505@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100908172902.6ed57505@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 11:29:02AM -0400, Jean Delvare wrote:
> On Wed, 8 Sep 2010 06:56:54 -0700, Guenter Roeck wrote:
> > Too bad - registers 0x16 and 0x17 exist on both 6658 and 6659. So the only way to detect 6659 
> > would be the address (0x4d or 0x4e), and we would mis-detect it on 0x4c. Is that worth it ?
> 
> I'd say adding support for the MAX6659 is worth it. Just don't add
> detection. That is, all of MAX6657, 6658 and 6658 should be detected as
> max6657, which has the minimum set of features. But if someone declares
> a "max6659" device either as part of the platform data or from
> user-space, then the driver should expose all the chip features.
> 
> Deal?
> 
I'd say yes, but then we would deliberately mis-detect the 6659 on address 0x4d and 0x4e,
which kind of hurts my consciousness. 

How about a middle ground - mis-detect it on address 0x4c, but detect it correctly
on 0x4d and 0x4e ? Should be ok if we add a note into the file and into the documentation,
and we would do as good as we can.

Guenter
