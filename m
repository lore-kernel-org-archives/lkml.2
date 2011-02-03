Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1BCTnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:43:50 -0500
Received: from mvp.visionpro.com ([63.91.95.19]:39415 "EHLO
	extern.visionpro.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756491Ab1BCTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:43:49 -0500
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Thu, 03 Feb 2011 11:43:46 -0800
Subject: Memset very slow
From: "Brian D. McGrew" <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C9704572.4797C%brian@visionpro.com>
Thread-Topic: Memset very slow
Thread-Index: AcvD2qui0ZuNMyexxECaW+q0w1/TUQ==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2011 19:43:46.0147 (UTC) FILETIME=[ABB87330:01CBC3DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

We're using Dell T5500 workstations and a kernel-2.6.18.194 in CentOS
5.5_x86-64. When we get these Dells, we have to flash the BIOS back to rev
A02 or else everything is so slow its unusable.  Now, the "new" T5500's are
here and we don't have the option to flash the BIOS back to A02 since it's a
faster processor and memory and a new motherboard.

We do memset in lots of places in our code, and in a couple places, the
memset is as large as 3GB.  Using the old machines with old BIOS, we were
fine but with a newer (current) BIOS on the new machines or the old
machines, memset is so slow it renders the system unusable.  But also after
using memset and that taking too long, everything else is slow, especially
system() calls.

On a properly configured "old" machine with the "old" BIOS, I can memset
3GBx2 in about .45 seconds and system calls return in under .25 seconds.
However, sing the new BIOS on either machine, that same memset takes about
20 seconds and system calls 6 to 7 seconds.

I grabbed the bleeding edge 2.6.37 from Elrepo and everything works fine,
new or old boxes and/or BIOS.

So, my question is, can someone explain to me what is going on here?  I am
not convinced this is a kernel problem just because a new kernel fixed it;
but, if there were changes related to this in the kernel, then what is the
oldest version I should be looking at to fix my issues?

Thanks!

-brian

