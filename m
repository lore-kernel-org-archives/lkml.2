Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2CYP1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 11:27:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38686 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab2CYP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 11:27:43 -0400
Date: Sun, 25 Mar 2012 19:27:36 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Message-ID: <20120325152736.GB4391@albatros>
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
> I'm surprised.  "mount -o remount,<options>" doesn't work on a mounted
> procfs, and nobody noticed until now?
> 
> The patch looks OK - has it been tested with both valid and invalid
> mount options?
> 
> 
> I redid the changelog:
> 
> 
> From: Vasiliy Kulikov <segoon@openwall.com>
> Subject: proc: fix mount -t proc -o AAA
> 
> The proc_parse_options() call from proc_mount() runs only once at boot
> time.  So on any later mount attempt, any mount options are ignored
> because ->s_root is already initialized.
> 
> As a consequence, "mount -o remount,<options>" will ignore the options.

No, remount works as it should.  _mount_ doesn't work.  Why it was not spotted:
Live case is:

1) upstart and systemd don't use /etc/fstab for /proc when mounting it at
the boot time.
2) dbus, etc. use /proc/ from the boot, so /proc cannot be umounted without
dbus stop.

So, to apply hidepid=X without system reboot procfs should be remounted
instead of umount+mount.

> To fix this, parse the mount options unconditionally.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
