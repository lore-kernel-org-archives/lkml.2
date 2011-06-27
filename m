Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1F0QLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:11:48 -0400
Received: from imr4.ericy.com ([198.24.6.8]:57781 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1F0QLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:11:45 -0400
Subject: Re: coretemp: Support for Intel Atom E6XX CPU (TunnelCreek)?
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Alexander Stein <alexander.stein@systec-electronic.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110627164108.777c2e28@endymion.delvare>
References: <201106271220.51953.alexander.stein@systec-electronic.com>
	 <20110627164108.777c2e28@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 27 Jun 2011 09:10:54 -0700
Message-ID: <1309191054.8271.636.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 10:41 -0400, Jean Delvare wrote:
> Hi Alexander,
> 
> On Mon, 27 Jun 2011 12:20:51 +0200, Alexander Stein wrote:
> > I have a patch (for v2.6.39) which adds support for Intel Atom E6XX 
> > (TunnelCreek) to coretemp. It's merely only adding x86_model 0x26.
> 
> You have a patch, great for you. What do you expect if you don't share
> it with us?
> 
> I'm not quite sure what your patch would be doing anyway. Since kernel
> 2.6.35, supported CPU models are detected using the DTS feature flag
> rather than the family and model numbers, so your Atom E6XX should be
> detected just fine.
> 
Maybe it is for Tjmax detection ?

> Note that there was a bug in kernels 2.6.35 to 2.6.39 with regards to
> TjMax guessing, which was fixed by Gunter Roeck with:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4f5f71a7abe329bdad81ee6a8e4545054a7cc30a
> You'll have to update to kernel version 2.6.39.2 to get this fix.
> 
> Do you happen to know what CPUs model number 0x26 covers? Do you know
> if this model supports MSR_IA32_TEMPERATURE_TARGET or not? The original
> Atom (model 0x1c) did not.
> 
> > But there are models (e.g. E660 and E660T) with different TjMax, namely 90 
> > degrees C and 110 degrees C. But these different model can't be detected by 
> > reading from hardware.
> 
> I would appreciate a patch to Documentation/hwmon/coretemp adding the
> known TjMax for these new Atom models.
> 
> BTW, is it really impossible to identify these models with a different
> TjMax? Don't the strings "E660" and "E660T" appear in the respective
> "model name" entries in /proc/cpuinfo?

I thought about replacing the manual TjMax detection code with code
using the model string to take care of problems like this - essentially
by providing a table with entries { model string, Tjmax } for each CPU
with Tjmax other than 100 degrees C. This way we could get rid of some
of the odd code we have today. Would that make sense ?

Thanks,
Guenter


