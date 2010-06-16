Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0FPItJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:49:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43728 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0FPItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:49:03 -0400
Date: Wed, 16 Jun 2010 10:49:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and
	gfn_to_pfn_atomic()
Message-ID: <20100616084900.GB17599@basil.fritz.box>
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E999.6050004@cn.fujitsu.com> <4C17625E.3020308@redhat.com> <20100616075918.GA17599@basil.fritz.box> <4C1885DF.80903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1885DF.80903@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The page is fine, the page tables are not.  Another task can munmap() the 
> thing while is_hwpoison_address() is running.

Ok  that boils down to me not seeing that source.

If it accesses the page tables yes then it's racy. But whoever
looked up the page tables in the first place should have
returned an -EFAULT. There's no useful address attached
to poison.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
