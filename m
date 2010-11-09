Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0KIKEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:04:07 -0500
Received: from mail.perches.com ([173.55.12.10]:4714 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab0KIKED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:04:03 -0500
Subject: Re: [PATCH 32/32] drivers/hwmon/w83781d.c: Use pr_fmt and
 pr_<level>
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101109103948.25919efe@endymion.delvare>
References: <20101020035346.GA20178@ericsson.com>
	 <1ce82b2a1c726d252483c508053eff046abcf132.1287556801.git.joe@perches.com>
	 <20101109103948.25919efe@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 02:04:02 -0800
Message-ID: <1289297042.1823.48.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 10:39 +0100, Jean Delvare wrote:
> On Tue, 19 Oct 2010 23:51:56 -0700, Joe Perches wrote:
> > Added #define pr_fmt KBUILD_MODNAME ": " fmt
> > Converted printks to pr_<level>
> > Coalesced any long formats
> > Removed prefixes from formats
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/hwmon/w83781d.c |   29 ++++++++++++++---------------
[]
> > @@ -1811,7 +1812,7 @@ w83781d_isa_found(unsigned short address)
> >  	if (inb_p(address + 2) != val
> >  	 || inb_p(address + 3) != val
> >  	 || inb_p(address + 7) != val) {
> > -		pr_debug("w83781d: Detection failed at step 1\n");
> > +		pr_debug("Detection failed at step 1\n");
> I think this would be the right time to change this to:
> 		pr_debug("Detection failed at step %d\n", 1);
> and do the same for all 6 messages below, so that the compiler can
> store the string only once in the binary.

Fine by me.


