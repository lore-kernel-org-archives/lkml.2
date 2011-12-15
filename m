Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab1LOL0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:26:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43397 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1LOL0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:26:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111215132902.d0a90a93696702e09b0c60bf@canb.auug.org.au>
References: <20111215132902.d0a90a93696702e09b0c60bf@canb.auug.org.au>
Date: Thu, 15 Dec 2011 12:26:49 +0100
X-Google-Sender-Auth: w0x1DKEpwlkrkeXr_6AADu3iGB4
Message-ID: <CAO+b5-pyo=kR5JuWbQzMd6X70s4AwSWJV7dq3F9BvwLwTDPm7A@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the target-merge tree
From: Bart Van Assche <bvanassche@acm.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 3:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the target-merge tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/infiniband/ulp/srpt/ib_srpt.c:48:39: fatal error: target/target_core_device.h: No such file or directory
>
> Caused by commit e0d85e515640 ("ib_srpt: Initial SRP Target merge for
> v3.2-rc1") interacting with commit c4795fb20edf ("target: header
> reshuffle, part2") from the target-updates tree which removed
> include/target/target_core_device.h.
>
> I tried to figure out what set of include files is now needed, but
> couldn't easily, so I have dropped the target-merge tree for today.

The (untested) patch below allowed me to make ib_srpt build again. By
the way, has the patch "ib_srpt: Make compilation with BUG=n proceed"
already been queued in the target-merge tree
(http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg10030.html)
?

Bart.

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c9503b8..0eb1fcc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -45,13 +45,8 @@
 #include <target/configfs_macros.h>
 #include <target/target_core_base.h>
 #include <target/target_core_base.h>
-#include <target/target_core_device.h>
+#include <target/target_core_fabric.h>
 #include <target/target_core_fabric_configfs.h>
-#include <target/target_core_fabric_lib.h>
-#include <target/target_core_fabric_ops.h>
-#include <target/target_core_tmr.h>
-#include <target/target_core_tpg.h>
-#include <target/target_core_transport.h>
 #include <target/target_core_configfs.h>
 #include "ib_srpt.h"
