Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1CGJyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:54:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59152 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1CGJyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:54:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Mar 2011 18:48:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCHv2 11/24] sys_swapon: do only cleanup in the cleanup
 blocks
Message-Id: <20110307184829.24192fb1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1299343345-3984-12-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-12-git-send-email-cesarb@cesarb.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Mar 2011 13:42:12 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> The only way error is 0 in the cleanup blocks is when the function is
> returning successfully. In this case, the cleanup blocks were setting
> S_SWAPFILE in the S_ISREG case. But this is not a cleanup.
> 
> Move the setting of S_SWAPFILE to just before the "goto out;" to make
> this more clear. At this point, we do not need to test for inode because
> it will never be NULL.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

