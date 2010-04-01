Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab0DATFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:05:02 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab0DATFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:05:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LOVYwH1lx+cTU9IN1pXOA/EDICgTuXw0OJiUJ1HvFhaz2k0pgZhyTBzw4bH+N93AS
	VN3vYbCCBM/WT6dL4La3Q==
Date: Thu, 1 Apr 2010 12:04:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] proc: don't take ->siglock for /proc/pid/oom_adj
In-Reply-To: <20100401153756.GD14603@redhat.com>
Message-ID: <alpine.DEB.2.00.1004011204430.30661@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com> <20100330174337.GA21663@redhat.com>
 <alpine.DEB.2.00.1003301329420.5234@chino.kir.corp.google.com> <20100331185950.GB11635@redhat.com> <alpine.DEB.2.00.1003311408520.31252@chino.kir.corp.google.com> <20100331230032.GB4025@redhat.com> <alpine.DEB.2.00.1004010128050.6285@chino.kir.corp.google.com>
 <20100401153756.GD14603@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Oleg Nesterov wrote:

> But. Unless we kill signal->oom_adj, we have another reason for ->siglock,
> we can't update both oom_adj and oom_score_adj atomically, and if we race
> with another thread they can be inconsistent wrt each other. Yes, oom_adj
> is not actually used, except we report it back to user-space, but still.
> 
> So, I am going to send 2 patches. The first one factors out the code
> in base.c and kills signal->oom_adj, the next one removes ->siglock.
> 

Great, thanks!
