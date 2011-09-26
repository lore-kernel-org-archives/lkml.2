Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1IZRbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:31:44 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:46423 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751385Ab1IZRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:31:42 -0400
Message-ID: <4E80B6FD.5050903@xenotime.net>
Date: Mon, 26 Sep 2011 10:31:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, sbradshaw@micron.com
Subject: Re: linux-next: Tree for Sept 26 (block/mtip32xx)
References: <20110926172348.be01ff9a1c16267ffd000d2a@canb.auug.org.au>
In-Reply-To: <20110926172348.be01ff9a1c16267ffd000d2a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 12:23 AM, Stephen Rothwell wrote:
> Hi all,


This driver has many build errors on i386.  CONFIG_COMPAT is not enabled,
so the compat_ulong_t etc. types are not available, causing beaucoup errors,
like:


drivers/block/mtip32xx/mtip32xx.c:95:2: error: expected specifier-qualifier-list before 'compat_ulong_t'
drivers/block/mtip32xx/mtip32xx.c: In function 'exec_drive_taskfile':
drivers/block/mtip32xx/mtip32xx.c:1656:3: error: 'compat_long_t' undeclared (first use in this function)
drivers/block/mtip32xx/mtip32xx.c:1656:3: note: each undeclared identifier is reported only once for each function it appears in
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1922:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927:3: warning: type defaults to 'int' in type name
drivers/block/mtip32xx/mtip32xx.c:1927:3: error: 'struct mtip_compat_ide_task_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c: In function 'mtip_block_initialize':
drivers/block/mtip32xx/mtip32xx.c:3073:2: warning: passing argument 2 of 'blk_queue_make_request' from incompatible pointer type
include/linux/blkdev.h:815:13: note: expected 'void (*)(struct request_queue *, struct bio *)' but argument is of type 'int (*)(struct request_queue *, struct bio *)'

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
