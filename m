Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0HEE6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:58:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47445 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0HEE6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:58:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 13:53:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/9] v4  Add mutex for add/remove of memory blocks
Message-Id: <20100805135314.7229d07c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C581C26.5080007@austin.ibm.com>
References: <4C581A6D.9030908@austin.ibm.com>
	<4C581C26.5080007@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 08:39:50 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Add a new mutex for use in adding and removing of memory blocks.  This
> is needed to avoid any race conditions in which the same memory block could
> be added and removed at the same time.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

But a nitpick (see below)

> ---
>  drivers/base/memory.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-08-02 13:35:00.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-08-02 13:45:34.000000000 -0500
> @@ -27,6 +27,8 @@
>  #include <asm/atomic.h>
>  #include <asm/uaccess.h>
>  
> +static struct mutex mem_sysfs_mutex;
> +

For static symbol of mutex, we usually do
	static DEFINE_MUTEX(mem_sysfs_mutex);

Then, extra calls of mutex_init() is not required.

