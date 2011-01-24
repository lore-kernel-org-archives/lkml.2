Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1AXAOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 19:14:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50557 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1AXAOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 19:14:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 24 Jan 2011 09:08:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Pavel Emelianov <xemul@openvz.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] Fix uninitialized variable use in
 mm/memcontrol.c::mem_cgroup_move_parent()
Message-Id: <20110124090844.e13e15af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LNX.2.00.1101222044580.7746@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101222044580.7746@swampdragon.chaosbits.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011 20:51:32 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> In mm/memcontrol.c::mem_cgroup_move_parent() there's a path that jumps to 
> the 'put_back' label
>   	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
>   	if (ret || !parent)
>   		goto put_back;
>  where we'll 
>   	if (charge > PAGE_SIZE)
>   		compound_unlock_irqrestore(page, flags);
> but, we have not assigned anything to 'flags' at this point, nor have we 
> called 'compound_lock_irqsave()' (which is what sets 'flags').
> So, I believe the 'put_back' label should be moved below the call to 
> compound_unlock_irqrestore() as per this patch. 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Andrew, I'll move my new patces onto this. So, please pick this one 1st.

