Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2AXXRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:17:38 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35972 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2AXXRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:17:36 -0500
Message-ID: <1327446992.11738.8.camel@work-vm>
Subject: Re: linux-next: build failure after merge of the input tree
From: John Stultz <john.stultz@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jan 2012 15:16:32 -0800
In-Reply-To: <20120124142516.07860a401ac9216cfa10a6ad@canb.auug.org.au>
References: <20120124142516.07860a401ac9216cfa10a6ad@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012423-7408-0000-0000-000002244AD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 14:25 +1100, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> After merging the input tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: ".ktime_get_monotonic_offset" [drivers/input/evdev.ko] undefined!
> 
> Caused by commit 04f2c50e5fd8 ("Input: add infrastructure for selecting
> clockid for event time stamps").
> 
> I have used the input tree from next-20120123 for today.

Huh.

ktime_get_monotonic_offset is a timekeeping core interface, defined
along with ktime_get 

Hrmmm.. Ah. I suspect this will fix it:


Export ktime_get_monotonic_offset for evdev

Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 9cf6bbb..9781add 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1230,6 +1230,8 @@ ktime_t ktime_get_monotonic_offset(void)
 	} while (read_seqretry(&xtime_lock, seq));
 	return timespec_to_ktime(wtom);
 }
+EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
+
 
 /**
  * xtime_update() - advances the timekeeping infrastructure




