Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab0DATNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:13:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47910 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0DATM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kpO1DmSyfUVkJObP5UcnJmSYqzUe/mt+2ANkzExfZfFnhvrznNwAzmWGFGohw4RJwG
         c7QkPHfXl2xysiniVUFpeMDORgKDYs5xD79AtvUpNIUMQU2oapT8z1faTZV2WKg5XNBh
         1vS6KxsBa6/Rc0hrSG5Z4Lu7lNvr/mTLtYIDs=
MIME-Version: 1.0
Date: Thu, 1 Apr 2010 14:12:57 -0500
Message-ID: <o2vd585dc4f1004011212s65cc2beewed2f19321210a249@mail.gmail.com>
Subject: Increased Latencies when upgrading kernel version
From: Taylor Lewick <taylor.lewick@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some time now we've been running an older kernel, 2.6.16.60.  When
we tried to upgrade, first going to 2.6.27.19 and then to 2.6.32.1 and
2.6.33.1 we noticed that latencies increased.  At first we noticed it
by doing network tests via udpping, netperf, etc.  We made some
tweaks, and were able to get network latency to within 1 to 2
microseconds of where we were previously on 2.6.16.60.  Then we did
some more testing, and noticed that system latency also seems higher.

We've done our tests on identical hardware servers, same NICs,
connected through same network gear.  Basically, we've tried to keep
everything identical except the kernel versions, and we are unable to
achieve the same performance for system latency on the newer kernels,
despite adjusting various kernel settings and recompiling.

The latency differences are about 15 microseconds per transaction.

At this point, I don't know what else to try.  I haven't played around
with the /proc/sys/kernel/sched_* paramaters under the newer kernels
yet.  Have tried changing pre-emption modes with little effect, in
fact, voluntary preemption seems to be peforming the best for us.

At this time the realtime patch isn't really an option for us to
consider, at least not yet.

Any suggestions?  Is this a known issue when upgrading to more recent
kernel versions?

Thanks,
Taylor
