Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1CETot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 14:44:49 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12532 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1CETos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 14:44:48 -0500
Date: Sat, 5 Mar 2011 20:44:14 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCHv2 15/24] sys_swapon: move setting of swapfilepages near
 use
In-Reply-To: <1299343345-3984-16-git-send-email-cesarb@cesarb.net>
Message-ID: <alpine.LNX.2.00.1103052041350.32044@swampdragon.chaosbits.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net> <1299343345-3984-16-git-send-email-cesarb@cesarb.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011, Cesar Eduardo Barros wrote:

> There is no reason I can see to read inode->i_size long before it is
> needed. Move its read to just before it is needed, to reduce the
> variable lifetime.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

This will save us having to do the assignment in many cases where we jump 
to one of the labels at the end uf the function before using the 
'swapfilepages' variable. Looks good to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

