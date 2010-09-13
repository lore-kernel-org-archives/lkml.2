Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0IMRRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:17:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49280 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0IMRRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:17:49 -0400
Date: Mon, 13 Sep 2010 22:47:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        stable@kernel.org
Subject: Re: [BUGFIX][PATCH] memcg: fix race in file_mapped accouting flag
 management
Message-ID: <20100913171741.GM17950@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100913160822.0c2cd732.kamezawa.hiroyu@jp.fujitsu.com>
 <20100913084741.GD17950@balbir.in.ibm.com>
 <AANLkTimsUQuEeS2QvSwY_WhnQY7n=D73fNmOoqgrTqbZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTimsUQuEeS2QvSwY_WhnQY7n=D73fNmOoqgrTqbZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com> [2010-09-14 00:28:30]:

> > In the situation above who has the PTE lock? Are we not synchronized
> > via the PTE lock such that add rmap and rm rmap, will not happen
> > simultaneously?
> >
> In this case, a process for map and one for unmap can be different.
> 
> Assume process A maps a file cache and process B not.
> While process A unmap a file, process B can map it.
> pte lock is no help.
>

Correct, so while the accounting is correct, the flag can definitely
go wrong. I misread your race description earlier.

Thanks! 

-- 
	Three Cheers,
	Balbir
