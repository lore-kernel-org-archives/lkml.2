Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2IEFfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:35:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:61682 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab2IEFfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:35:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,372,1344236400"; 
   d="scan'208";a="188922516"
Message-ID: <5046E47C.2020405@intel.com>
Date: Wed, 05 Sep 2012 13:34:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        "Ren, Yongjie" <yongjie.ren@intel.com>
Subject: Re: [PATCH] xen: fix logical error in tlb flushing
References: <1345798513-3566-1-git-send-email-alex.shi@intel.com> <5037A8E7020000780008A78B@nat28.tlf.novell.com> <20120824181721.GC15167@konrad-lan.dumpdata.com> <5037E7ED020000780008A7BD@nat28.tlf.novell.com>
In-Reply-To: <5037E7ED020000780008A7BD@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2012 03:45 AM, Jan Beulich wrote:

>>>> On 24.08.12 at 20:17, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> On Fri, Aug 24, 2012 at 04:16:39PM +0100, Jan Beulich wrote:
>>>>>> On 24.08.12 at 10:55, Alex Shi <alex.shi@intel.com> wrote:
>>>> While TLB_FLUSH_ALL gets passed as 'end' argument to
>>>> flush_tlb_others(), the Xen code was made to check its 'start'
>>>> parameter. That may give a incorrect op.cmd to MMUEXT_INVLPG_MULTI
>>>> instead of MMUEXT_TLB_FLUSH_MULTI. Then it causes some page can not
>>>> be flushed from TLB.
>>>>
>>>> This patch fixed this issue.
>>>>
>>>> Reported-by: Jan Beulich <jbeulich@suse.com>
>>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>>
>>> Acked-by: Jan Beulich <jbeulich@suse.com>



CC to Yongjie,
Could you like to test this patch on PV guest

>>
>> How can I reproduce this

>

> I don't know, I spotted this while looking at the code.


Again, since the old buggy code doesn't cause trouble in PV guest, guess
the hypercall for MMUEXT_INVLPG_MULTI was translated or treated as
MMUEXT_TLB_FLUSH_MULTI. If so, believe correct this will bring a big
performance benefit.


