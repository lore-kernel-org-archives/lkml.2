Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2G0VDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:03:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65369 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2G0VDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:03:17 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 27 Jul 2012 14:03:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (applesmc) Decode and act on
 read/write status codes
Message-ID: <20120727210337.GA11324@roeck-us.net>
References: <1343412766-552-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343412766-552-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Jul 27, 2012 at 08:12:46PM +0200, Henrik Rydberg wrote:
> The behavior of the SMC has changed several times over the years,
> causing read failures in the driver. It seems the problem can be
> explained by a shift in SMC speed combined with improper action on
> status codes.
> 
> We should first wait for the SMC to settle, which was the most
> frequent response on the old slow machines. Then, if the SMC is busy,
> we need to try again later by resending the command. This was the most
> likely response until 2012. Now, with a shorter wait time, we are
> again most likely to poll while the SMC is settling, and as a result
> we see high failure rates on many old and new models.
> 
> With the distinction between busy and failure, we can also wait longer
> before retrying, without sacrificing speed.  This seems to bring
> failures down to virtually zero on all models.
> 
> Tested on: MBA1,1 MBA3,1 MBA5,1 MBA5,2 MBP9,2
> 
> Tested-by: Adam Somerville <adamsomerville@gmail.com>
> Tested-by: Hubert Eichner <hubert.georg.eichner@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied.

> ---
> Hi Guenter,
> 
> It turns out the mid-2012 Macbooks need additional changes in order to
> work reliably. Since the needed change is a great improvement also on
> other problematic machines, it would make a lot of sense if this patch
> could be squeezed into the merge window.
> 
> As I mentioned in a previous mail, backporting e70acc100 by itself is
> not a good idea, but together with this patch it should be ok.
> 
I think the patches should mature a bit in mainline. We can decide in a month
or so if we want to backport them to previous releases.

Thanks,
Guenter
