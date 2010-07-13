Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0GMB3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:29:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab0GMB3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:29:39 -0400
Date: Mon, 12 Jul 2010 18:29:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: axel.lin@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] edd: fix possible memory leak in edd_init() error path
Message-Id: <20100712182910.7b69b493.akpm@linux-foundation.org>
In-Reply-To: <AANLkTik3qDmpRS9HwFFzCfyHMrUd9ZnaR1A39jUo0cbt@mail.gmail.com>
References: <1278672607.1335.3.camel@mola>
	<20100712124904.d05242d2.akpm@linux-foundation.org>
	<AANLkTik3qDmpRS9HwFFzCfyHMrUd9ZnaR1A39jUo0cbt@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 09:17:58 +0800 Axel Lin <axel.lin@gmail.com> wrote:

> >> +
> >> +out:
> >> + __ __ while (--i >= 0) {
> >> + __ __ __ __ __ __ edev = edd_devices[i];
> >> + __ __ __ __ __ __ if (edev)
> >
> > This test is unneeded?
> 
> right. a revised version is on the way.

I already did the below, which you were cc'ed on?

--- a/drivers/firmware/edd.c~edd-fix-possible-memory-leak-in-edd_init-error-path-fix
+++ a/drivers/firmware/edd.c
@@ -778,11 +778,8 @@ edd_init(void)
 	return 0;
 
 out:
-	while (--i >= 0) {
-		edev = edd_devices[i];
-		if (edev)
-			edd_device_unregister(edev);
-	}
+	while (--i >= 0)
+		edd_device_unregister(edd_devices[i]);
 	kset_unregister(edd_kset);
 	return rc;
 }
_

