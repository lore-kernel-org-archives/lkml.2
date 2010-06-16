Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab0FPLm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:42:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41531 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab0FPLm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:42:26 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 07:42:25 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NEVe7p9EhgEfADt1ZBe7V36ZYQ3197PKgs3a89YMWychgP9gT9fauh868aaZIEpKQ3
         6ieOvPzdG9ag7x4FrhSH1UvnZydcxoFCm42w2EMhdMhxHV8gX95rOzSgqMeb/5qhtE8H
         1iJvm5iUjywzYd/NnxVp18kwTBmvySyQJRpZs=
MIME-Version: 1.0
In-Reply-To: <18402.1276625268@redhat.com>
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
	<AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
	<20100613194949.GC8055@thunk.org>
	<AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
	<20100614184244.GA11480@elliptictech.com>
	<20100614214646.GF6666@thunk.org>
	<AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com>
	<18402.1276625268@redhat.com>
Date: Wed, 16 Jun 2010 12:37:22 +0100
X-Google-Sender-Auth: 0hUdrIgRj_2ZGI1Gp2-nqDstyCI
Message-ID: <AANLkTilZElLEBJDjfpZVx72uDR-x_3t14Jkga5eHy3wf@mail.gmail.com>
Subject: Re: Why is kslowd accumulating so much CPU time?
From: Andy Whitcroft <apw@canonical.com>
To: David Howells <dhowells@redhat.com>
Cc: tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you see what they're doing?
>
>        watch -n0 cat /sys/kernel/debug/slow_work/runqueue

Turned on the debugging and applied the patch from Ted, and when
things are bad I see constant cycling of all four threads in the
output showing similar to the below, note only one thread shows at a
time:

Every 0.1s: cat /sys/kernel/debug/slow_work/runqueue    Wed Jun 16 12:34:52 2010

THR PID   ITEM ADDR        FL MARK  DESC
=== ===== ================ == ===== ==========
   0   897 ffff88012bb07510 12  20ms DRM_CRTC_HELPER: i915@pci:0000:00:02.0

When things are working well I see the same output appearing for one
update, about every 10s.

-apw
