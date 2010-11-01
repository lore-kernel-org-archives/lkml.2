Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0KAUZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:25:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:60184 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab0KAUZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:25:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dimitrios Apostolou <jimis@gmx.net>
Subject: Re: 2.6.36 io bring the system to its knees
Date: Mon, 1 Nov 2010 01:09:34 +0000 (UTC)
Message-ID: <ial40e$jpj$1@dough.gmane.org>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
	<AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
	<AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
	<AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
	<20101031012224.GA8007@localhost> <20101031015132.GA10086@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 178-14-100.dynamic.cyta.gr
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

On Sun, 31 Oct 2010 09:51:32 +0800, Wu Fengguang wrote:
> It may also help to lower the dirty ratio.
> 
> echo 5 > /proc/sys/vm/dirty_ratio
> 
> Memory pressure + heavy write can easily hurt responsiveness.
> 
> - eats up to 20% (the default value for dirty_ratio) memory with dirty
>   pages and hence increase the memory pressure and number of swap IO

My experience has been different with that. Wouldn't it make more sense 
to _increase_ dirty_ratio (to 50 lets say) and at the same time decrease 
dirty_background_ratio? That way writing to disk starts early, but the 
related apps stall waiting for I/O only when dirty_ratio is reached.


Thanks, 
Dimitris

> 
> - the file copy makes the device write congested and hence makes
>   pageout() easily blocked in get_request_wait()
> 
> As a result every application may be slowed down by the heavy swap IO
> when page fault as well as being blocked when allocating memory (which
> may go into direct reclaim and then call pageout()).
> 
> Thanks,
> Fengguang


