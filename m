Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2EEEUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:20:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2EEETr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <4FA49B49.9000203@gmail.com>
References: <1336186227-1941-1-git-send-email-pierre@spotify.com>
	<4FA49B49.9000203@gmail.com>
Date: Sat, 5 May 2012 06:19:46 +0200
Message-ID: <CAPXGRD=Z8fZOsk-PYbh6weBoFfeJFstdhDufBfyxUFgOL1BPng@mail.gmail.com>
Subject: Re: [PATCH 1/1] procfs: expose umask in stat and status
From: Pierre Carrier <pierre@spotify.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 5:15 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> How is it useful to display numeric -ENOENT in a /proc file?

The fields in stat are looked up by index, so they should all always appear.
Sticking to a numerical value makes both this code and parsing
reasonably straightforward.

Given expected values are masks, a negative value makes a good marker.
Overall I don't see a compelling reason to avoid an errno.
They seem common in kernel outputs and benefit from some tooling
(self-promotion: [1]).

Would you have a better idea in mind?

> So sometimes "Umask:" is displayed, sometimes not...

Well, it is displayed whenever available (which sounds better to my ear).
This seemed consistent with the current practices: status already has
guards for FDSize, Groups, VmPeak, VmSize, VmLck, VmPin, VmHWM, VmRSS,
VmData, VmStk, VmExe, VmLib, VmPTE, VmSwap.

In all honesty I can't think of a realistic situation where one would
look for a umask in a task that doesn't have one.

-- 
Pierre

[1] https://github.com/pcarrier/stuff/blob/master/sys/errnos.c
