Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1JJAfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 20:35:23 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:54523 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1JJAfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 20:35:22 -0400
Subject: Re: [PATCH v9]: Improve performance of LZO/plain hibernation, check
 image with CRC32
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 10 Oct 2011 11:35:20 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318206920.1991.27.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 10:53 +1100, Bojan Smojver wrote:
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -27,6 +27,7 @@ config HIBERNATION
>         select HIBERNATE_CALLBACKS
>         select LZO_COMPRESS
>         select LZO_DECOMPRESS
> +       select CRC32
>         ---help---
>           Enable the suspend to disk (STD) functionality, which is usually
>           called "hibernation" in user interfaces.  STD checkpoints the 

Not sure whether this is really required (I mean select CRC32). The docs
say:
------------------
config CRC32
        tristate "CRC32 functions"
        default y
        select BITREVERSE
        help
          This option is provided for the case where no in-kernel-tree
          modules require CRC32 functions, but a module built outside the
          kernel tree does. Such modules that use library CRC32 functions
------------------

Obviously, hibernation is in the kernel, so maybe we don't need this
after all.

If you know for sure, feel free to point it out.

-- 
Bojan

