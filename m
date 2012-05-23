Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871Ab2EWEBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:01:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33925 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2EWEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:01:23 -0400
Date: Tue, 22 May 2012 20:59:50 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, ccross@android.com,
        gregkh@linuxfoundation.org, keescook@chromium.org, tony.luck@intel.com,
        arnd@arndb.de, john.stultz@linaro.org, shuahkhan@gmail.com,
        arve@android.com, rebecca@android.com, jj@chaosbits.net,
        rdunlap@xenotime.net, sboyd@codeaurora.org, thomas@m3y3r.de,
        akpm@linux-foundation.org, marco.stornelli@gmail.com,
        xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au
Subject: Re: [PATCH/RFC] Make sure linux_banner is the first message in
 log_buf
Message-ID: <20120523035949.GA4966@lizard>
References: <1337696279-8994-3-git-send-email-anton.vorontsov@linaro.org>
 <CAMbhsRQPYzXregvvgQZD1dV_m4tgx0hQqnYPyaO3mV0hRpc5JQ@mail.gmail.com>
 <20120523023513.GA22235@lizard>
 <20120522.225512.1427265315315004011.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120522.225512.1427265315315004011.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:55:12PM -0400, David Miller wrote:
> From: Anton Vorontsov <anton.vorontsov@linaro.org>
> Date: Tue, 22 May 2012 19:35:16 -0700
> 
> > For scripting it is important to have a consistent header that tells
> > where the kernel log starts. At least to me it always seemed that
> > linux_banner served this purpose.
> 
> Your change will not achieve this goal, many architectures
> print things long before control passes to init/main.c

If they use printk, we'll catch these messages, no? It is true that
if they just write to the HW directly, the messages are lost for us,
and there's nothing we can do about it (and we don't see these
messages from the kernel anyway, neither in dmesg, nor in pstore).

So, for serial (or arch-specific) console it is still cumbersome to
make proper parsing of all messages, but for pstore/ramconsole it is
OK. So, I dunno. I guess I'll have to add a custom header to pstore,
heh.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
