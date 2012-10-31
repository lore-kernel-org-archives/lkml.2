Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935930Ab2JaVhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:37:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61585 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab2JaVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:37:07 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce managed input devices (add devres support)
Date: Wed, 31 Oct 2012 14:37:01 -0700
Message-ID: <5132958.JXBGbd4rj1@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc3+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121031210532.GX2945@htj.dyndns.org>
References: <20121023053513.GA15642@core.coreip.homeip.net> <20121031210532.GX2945@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 31, 2012 02:05:32 PM Tejun Heo wrote:
> Hello, Dmitry.
> 
> On Mon, Oct 22, 2012 at 10:35:14PM -0700, Dmitry Torokhov wrote:
> > There is a demand from driver's writers to use managed devices framework
> > for their drivers. Unfortunately up to this moment input devices did not
> > provide support for managed devices and that lead to mixing two styles
> > of resource management which usually introduced more bugs, such as
> > manually unregistering input device but relying in devres to free
> > interrupt handler which (unless device is properly shut off) can cause
> > ISR to reference already freed memory.
> > 
> > This change introduces devm_input_allocate_device() that will allocate
> > managed instance of input device so that driver writers who prefer
> > using devm_* framework do not have to mix 2 styles.
> 
> It generally looks good to me although it's a bit unusual to use
> devres on device.  Given the way input_dev is used, it probably makes
> sense, I guess.
> 
> One thing tho.  If possible and there aren't too many, wouldn't it be
> better to convert all to use devres.  Having two different lifetime
> fules tends to lead to gotchas.

Not all drivers use devres for rest of their resources so it makes sense
to have unmanaged versions (like we have request_irq/devm_request_irq).
Besides:

[dtor@dtor-ws vmci]$ grep -r input_allocate_device drivers/ | wc -l
298

so I'd rather not ;)

Thanks.

-- 
Dmitry

