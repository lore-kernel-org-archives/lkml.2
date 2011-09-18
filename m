Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1IRTFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 15:05:11 -0400
Received: from shutemov.name ([188.40.19.243]:35201 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab1IRTFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 15:05:10 -0400
Date: Sun, 18 Sep 2011 22:05:09 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 1/7] Basic kernel memory functionality for the Memory
 Controller
Message-ID: <20110918190509.GC28057@shutemov.name>
References: <1316051175-17780-1-git-send-email-glommer@parallels.com>
 <1316051175-17780-2-git-send-email-glommer@parallels.com>
 <20110917174535.GA1658@shutemov.name>
 <4E7567E0.9010401@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7567E0.9010401@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 12:39:12AM -0300, Glauber Costa wrote:
> > No kernel memory accounting for root cgroup, right?
> Not sure. Maybe kernel memory accounting is useful even for root cgroup. 
> Same as normal memory accounting... what we want to avoid is kernel 
> memory limits. OTOH, if we are not limiting it anyway, accounting it is 
> just useless overhead... Even the statistics can then be gathered 
> through all
> the proc files that show slab usage, I guess?

It's better to leave root cgroup without accounting. At least for now.
We can add it later if needed.

> >
> >> @@ -3979,6 +3999,10 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
> >>   		else
> >>   			val = res_counter_read_u64(&mem->memsw, name);
> >>   		break;
> >> +	case _KMEM:
> >> +		val = res_counter_read_u64(&mem->kmem, name);
> >> +		break;
> >> +
> >
> > Always zero in root cgroup?
> 
> Yes, if we're not accounting, it should be zero. WARN_ON, maybe?

-ENOSYS?

-- 
 Kirill A. Shutemov
