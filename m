Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2IETJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:09:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60584 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2IETJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:09:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120905184708.GC16230@one.firstfloor.org>
References: <20120905102156.9423.27806.stgit@localhost.localdomain>
	<20120905103237.9726.56131.stgit@localhost.localdomain>
	<20120905184708.GC16230@one.firstfloor.org>
Date: Wed, 5 Sep 2012 12:09:50 -0700
Message-ID: <CA+8MBbKx7x=MxgtV5URYuDWQcxz0nqohVB8gRpBHtDxqMBb9uw@mail.gmail.com>
Subject: Re: [PATCH] [mcelog] Start using the new sysfs tunables location
From: Tony Luck <tony.luck@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, ak@linux.intel.com,
        bp@amd64.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, ananth@in.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 11:47 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Sep 05, 2012 at 04:02:37PM +0530, Naveen N. Rao wrote:
>> All the current mce tunables are now available under
>> /sys/devices/system/machinecheck. Start using this new location, but fall back
>> to the older per-cpu location so that we continue working with older kernels.
>
> Who did that change in the kernel?
>
> That breaks Linus rule that the kernel should not break userland.
> Kernel needs to fix that.

The change is still under discussion. Stage one is to add the new global
pathnames in addition to keeping the old per-cpu ones. Also fix all utilities
(just mcelog(8) as far as we know) to prefer the new paths.

After some time[1] ... delete the old paths. This is allowable under Linus'
modified edict that you can change ABI "if nobody complains". If we wait
long enough that the new mcelog is widely deployed, then nobody should
complain.

-Tony

[1] several years - not just a kernel release or two.
