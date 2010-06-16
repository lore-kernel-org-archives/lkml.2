Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0FPH7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:59:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0FPH7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:59:23 -0400
Date: Wed, 16 Jun 2010 09:59:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and
	gfn_to_pfn_atomic()
Message-ID: <20100616075918.GA17599@basil.fritz.box>
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E999.6050004@cn.fujitsu.com> <4C17625E.3020308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C17625E.3020308@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 02:22:06PM +0300, Avi Kivity wrote:
> Too much duplication.  How about putting the tail end of the function in a 
> common helper (with an inatomic flag)?
>
> btw, is_hwpoison_address() is racy.  While it looks up the address, some 
> other task can unmap the page tables under us.

Where is is_hwpoison_address() coming from? I can't find it anywhere.

Anyways hwpoison will not remove the page as long as there
is a reference to it, so as long as you get the reference
race free against another task you're ok. Of course there might 
be always an error in between and the hardware may poison
the data, but we don't try to handle all kernel errors.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
