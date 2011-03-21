Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1CUDKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 23:10:46 -0400
Received: from lo.gmane.org ([80.91.229.12]:50285 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1CUDKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 23:10:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be
 overridden
Date: Mon, 21 Mar 2011 03:10:26 +0000 (UTC)
Message-ID: <im6fj2$576$1@dough.gmane.org>
References: <20100825002258.GD28360@kryten>
	<m139u37cii.fsf@fess.ebiederm.org> <4D771EE6.5050404@linux.vnet.ibm.com>
	<20110309122046.GC16951@cr0.redhat.com> <20110309234657.264d3080@kryten>
	<20110309142108.GD16951@cr0.redhat.com> <20110314181315.GA16075@in.ibm.com>
	<AANLkTi=aDzCaa7_=5XTrnJCzmZPrDy3omXwDarEF8XmH@mail.gmail.com>
	<20110315165219.GA22509@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 219.144.238.61
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kexec@lists.infradead.org, linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 22:22:19 +0530, Mahesh J Salgaonkar wrote:

> On Tue, Mar 15, 2011 at 03:52:38PM +0800, Américo Wang wrote:
>> On Tue, Mar 15, 2011 at 2:13 AM, Mahesh J Salgaonkar
>> <mahesh@linux.vnet.ibm.com> wrote:
>> >
>> > During free we do free all of them including RMO region. But since
>> > the rtas region is always on top of RMO, crashkernel memory overlaps
>> > rtas region and we endup freeing that even, which is causing the
>> > crash.
>> >
>> >
>> Okay, but with this patch applied, we will just ignore rtas region,
>> right?
> Correct.
>> Thus, when I echo 0 to free all the 128M crashkernel memory, the final
>> result will be 32M left, which means crash_size will still show 32M.
>> This looks odd.
>> 
>> How about skipping the 32M as a whole? I mean once the region being
>> freed has overlap with this rtas region, skip the whole rtas region,
>> and let crash_size
>> show 0?
> The existing code from crash_shrink_memory() function reduces the crash
> size to 0 when echo'ed 0. I did test this patchset and verified that
> /sys/kernel/kexec_crash_size show 0 value.

Oh, ok.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

