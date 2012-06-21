Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab2FURH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:07:59 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:39632 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913Ab2FURH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:07:58 -0400
Date: Thu, 21 Jun 2012 19:07:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
Message-ID: <20120621190743.2e6601f6@endymion.delvare>
In-Reply-To: <4FE34BCB.5050305@linux.intel.com>
References: <20120621162807.3c621d46@endymion.delvare>
	<4FE34BCB.5050305@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 09:28:59 -0700, H. Peter Anvin wrote:
> Good spotting, but I'm worried this is the wrong fix.
> 
> This is a userspace ABI change, and the and we have used "dts" for debug
> store (debug trace store?) for a very long tie, whereas digital thermal
> sensor only has been used since 2010; another *major* question is which
> of these is more likely to be of interest to userspace.

I am aware of this problem. I found the bug because I was looking for
the Digital Thermal Sensor feature, and /proc/cpuinfo said "dts" but
the driver wouldn't work, this confused me. So at least the Digital
Thermal Sensor is of interest. That being said I believe interest is
more from humans than software, which is why I do not feel bad changing
it. The current situation could already lead to false positives anyway,
both for humans and software.

If your "right fix" is to find something else for the Digital Thermal
Sensor, I doubt you can find something that won't confuse people even
more. Especially when there is also the Package Thermal Sensor feature
which is properly labeled "pts" already. "DTS" is widely used in the
technical documentation to refer to this feature.

And FWIW, X86_FEATURE_DS has no user in the kernel. Doesn't look like a
key feature to me, but maybe my view is biased...

-- 
Jean Delvare
