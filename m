Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1A0Qlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:41:47 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34005 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1A0Qlr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Thu, 27 Jan 2011 11:41:47 -0500
Message-Id: <4D41AE51020000780002ED8F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 27 Jan 2011 16:41:37 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <fanhenglong@huawei.com>,
        "Kaushik Barde" <kbarde@huawei.com>,
        "Kenneth Lee" <liguozhu@huawei.com>,
        "linqaingmin" <linqiangmin@huawei.com>, <wangzhenguo@huawei.com>,
        "Xiaowei Yang" <xiaowei.yang@huawei.com>,
        "Wu Fengguang" <fengguang.wu@intel.com>,
        "Nick Piggin" <npiggin@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: One (possible) x86 get_user_pages bug
References: <4D416D9A.9010603@huawei.com>
 <4D41A651020000780002ED36@vpn.id2.novell.com>
 <1296145502.15234.235.camel@laptop>
In-Reply-To: <1296145502.15234.235.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.01.11 at 17:25, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-01-27 at 16:07 +0000, Jan Beulich wrote:
>> 
>> Nick, based on your doing of the initial implementation, would
>> you be able to estimate whether disabling get_user_pages_fast()
>> altogether for Xen would be performing measurably worse than
>> adding the locks (but continuing to avoid acquiring mm->mmap_sem)
>> as suggested by Xiaowei? That's of course only if the latter is correct
>> at all, of which I haven't fully convinced myself yet. 
> 
> Adding the lock will result in deadlocks, __get_user_pages_fast() is
> used from NMI context.
> 
> Then again, I've got no clue if Xen even has NMIs..

It does, but not in a way that would be usable for perf events
afaict, so that code path should be dead under Xen. (We don't
even build the offending source file in our kernels, but I'm not
sure how pv-ops deals with situations like this - Jeremy?)

Jan

