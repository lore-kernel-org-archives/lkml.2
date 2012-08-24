Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab2HXTpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:45:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41745 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab2HXTpg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 24 Aug 2012 15:45:36 -0400
Message-Id: <5037E7ED020000780008A7BD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Aug 2012 20:45:32 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Alex Shi" <alex.shi@intel.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] xen: fix logical error in tlb flushing
References: <1345798513-3566-1-git-send-email-alex.shi@intel.com>
 <5037A8E7020000780008A78B@nat28.tlf.novell.com>
 <20120824181721.GC15167@konrad-lan.dumpdata.com>
In-Reply-To: <20120824181721.GC15167@konrad-lan.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.08.12 at 20:17, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Fri, Aug 24, 2012 at 04:16:39PM +0100, Jan Beulich wrote:
>> >>> On 24.08.12 at 10:55, Alex Shi <alex.shi@intel.com> wrote:
>> > While TLB_FLUSH_ALL gets passed as 'end' argument to
>> > flush_tlb_others(), the Xen code was made to check its 'start'
>> > parameter. That may give a incorrect op.cmd to MMUEXT_INVLPG_MULTI
>> > instead of MMUEXT_TLB_FLUSH_MULTI. Then it causes some page can not
>> > be flushed from TLB.
>> > 
>> > This patch fixed this issue.
>> > 
>> > Reported-by: Jan Beulich <jbeulich@suse.com>
>> > Signed-off-by: Alex Shi <alex.shi@intel.com>
>> 
>> Acked-by: Jan Beulich <jbeulich@suse.com>
> 
> How can I reproduce this

I don't know, I spotted this while looking at the code.

> and should this also go to stable@kernel.org?

No, the problem got introduced in 3.6-rc1.

Jan

