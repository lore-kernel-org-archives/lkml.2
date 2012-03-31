Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab2CaNvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 09:51:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45277 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab2CaNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 09:51:29 -0400
Date: Sat, 31 Mar 2012 17:51:13 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Message-ID: <20120331135113.GA2845@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
 <20120323171058.GA3279@albatros>
 <20120323161504.dced28b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323161504.dced28b9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 16:15 -0700, Andrew Morton wrote:
> From: Vasiliy Kulikov <segoon@openwall.com>
> Subject: proc: fix mount -t proc -o AAA
> 
> The proc_parse_options() call from proc_mount() runs only once at boot
> time.  So on any later mount attempt, any mount options are ignored
> because ->s_root is already initialized.
> 
> As a consequence, "mount -o remount,<options>" will ignore the options.

s/-o remount,<options>/-o <options>/

> To fix this, parse the mount options unconditionally.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

So, it should look like:

---
The proc_parse_options() call from proc_mount() runs only once at boot
time.  So on any later mount attempt, any mount options are ignored
because ->s_root is already initialized.

As a consequence, "mount -o <options>" will ignore the options.  The only
way to change mount options is "mount -o remount,<options>".

To fix this, parse the mount options unconditionally.
---

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
