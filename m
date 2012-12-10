Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2LJCV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:21:57 -0500
Received: from ares07.inai.de ([5.9.24.206]:43869 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab2LJCV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:21:56 -0500
Date: Mon, 10 Dec 2012 03:21:53 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
In-Reply-To: <20121116155603.2118394c.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1212100320180.25777@nerf07.vanv.qr>
References: <20121114151937.344922058@openvz.org> <20121114152239.936025193@openvz.org> <20121116155603.2118394c.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-11-17 00:56, Andrew Morton wrote:
>>  | pos:	0
>>  | flags:	02000000
>>  | inotify wd:        3 ino:             9e7e
>>  | inotify wd:        2 ino:             a111
>>  | inotify wd:        1 ino:            6b149[...]
>
>This is a lousy output format.  It's sort-of like a sensible set of
>name-value tuples: "name:value name:value name:value" but
>
>c) inotify-wd is secretly printed in decimal while everything else
>   is in hex.
>
>What happens if we do something like the below (which will require a
>changelog update)?
>
>@@ -59,7 +59,7 @@ static int show_mark_fhandle(struct seq_
> 	f.handle.handle_type = ret;
> 	f.handle.handle_bytes = size * sizeof(u32);
> 
>-	ret = seq_printf(m, "fhandle-bytes: %8x fhandle-type: %8x f_handle: ",
>+	ret = seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
> 			 f.handle.handle_bytes, f.handle.handle_type);

Why don't we actually make sure to print a 0x prefix when it's hex
and 0 on octal? Then it should be clear what base these lines are in.
(That would also be a good idea for the rest of procfs files, but I
reckon they cannot be easily changed.)
