Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822Ab2JaVFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:05:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679Ab2JaVFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:05:36 -0400
Date: Wed, 31 Oct 2012 14:05:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce managed input devices (add devres
 support)
Message-ID: <20121031210532.GX2945@htj.dyndns.org>
References: <20121023053513.GA15642@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023053513.GA15642@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

On Mon, Oct 22, 2012 at 10:35:14PM -0700, Dmitry Torokhov wrote:
> There is a demand from driver's writers to use managed devices framework
> for their drivers. Unfortunately up to this moment input devices did not
> provide support for managed devices and that lead to mixing two styles
> of resource management which usually introduced more bugs, such as
> manually unregistering input device but relying in devres to free
> interrupt handler which (unless device is properly shut off) can cause
> ISR to reference already freed memory.
> 
> This change introduces devm_input_allocate_device() that will allocate
> managed instance of input device so that driver writers who prefer
> using devm_* framework do not have to mix 2 styles.

It generally looks good to me although it's a bit unusual to use
devres on device.  Given the way input_dev is used, it probably makes
sense, I guess.

One thing tho.  If possible and there aren't too many, wouldn't it be
better to convert all to use devres.  Having two different lifetime
fules tends to lead to gotchas.

Thanks!

-- 
tejun
