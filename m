Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1LGAES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:04:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44588 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1LGAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:04:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 7 Dec 2011 09:02:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members
 to /proc/$pid/stat v2
Message-Id: <20111207090259.e2296dd3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111206225315.GA20459@moon>
References: <20111205182010.GV14515@moon>
	<20111206140833.3b43fbeb.akpm@linux-foundation.org>
	<20111206221515.GP29781@moon>
	<20111206225315.GA20459@moon>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 02:53:15 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:
 
> Index: linux-2.6.git/Documentation/filesystems/proc.txt
> ===================================================================
> --- linux-2.6.git.orig/Documentation/filesystems/proc.txt
> +++ linux-2.6.git/Documentation/filesystems/proc.txt
> @@ -305,6 +305,9 @@ Table 1-4: Contents of the stat files (a
>    blkio_ticks   time spent waiting for block IO
>    gtime         guest time of the task in jiffies
>    cgtime        guest time of the task children in jiffies
> +  start_data    address above which program data is placed
> +  end_data      address above which program data is placed
> +  start_brk     address above which program data can be expanded with brk() call
>  ..............................................................................
> 
nitpick.

After reading Wikipedia, http://en.wikipedia.org/wiki/Data_segment

I prefer

start_data   address above program data+bss is placed.
end_data     address below program data+bss is placed
start_break  address above which program heap can be expaned with brk() call

rather than just 'data'. 

Thanks,
-Kame

