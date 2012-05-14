Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2ENIzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:55:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45972 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2ENIzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:55:49 -0400
Message-ID: <4FB0C888.8070805@gmail.com>
Date: Mon, 14 May 2012 16:55:36 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephane Marchesin <marcheu@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <ffwll.ch@google.com>, Rob Clark <rob.clark@linaro.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/10] shmem: replace page if mapping excludes its zone
References: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils> <alpine.LSU.2.00.1205120453210.28861@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205120453210.28861@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 07:59 PM, Hugh Dickins wrote:
> +	VM_BUG_ON(!PageLocked(oldpage));
> +	__set_page_locked(newpage);
> +	VM_BUG_ON(!PageUptodate(oldpage));
> +	SetPageUptodate(newpage);
> +	VM_BUG_ON(!PageSwapBacked(oldpage));
> +	SetPageSwapBacked(newpage);
> +	VM_BUG_ON(!swap_index);
> +	set_page_private(newpage, swap_index);
> +	VM_BUG_ON(!PageSwapCache(oldpage));
> +	SetPageSwapCache(newpage);
> +

Are all of these VM_BUG_ON's necessary?
