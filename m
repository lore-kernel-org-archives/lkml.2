Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2IEIDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:03:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60048 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IEIDc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 5 Sep 2012 04:03:32 -0400
Message-Id: <504723A70200007800098A79@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 05 Sep 2012 09:04:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: "Yongjie Ren" <yongjie.ren@intel.com>, <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] xen: fix logical error in tlb flushing
References: <1345798513-3566-1-git-send-email-alex.shi@intel.com>
 <5037A8E7020000780008A78B@nat28.tlf.novell.com>
 <20120824181721.GC15167@konrad-lan.dumpdata.com>
 <5037E7ED020000780008A7BD@nat28.tlf.novell.com>
 <5046E47C.2020405@intel.com>
In-Reply-To: <5046E47C.2020405@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.09.12 at 07:34, Alex Shi <alex.shi@intel.com> wrote:
> On 08/25/2012 03:45 AM, Jan Beulich wrote:
>>>>> On 24.08.12 at 20:17, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>>> How can I reproduce this
>>
>> I don't know, I spotted this while looking at the code.
> 
> Again, since the old buggy code doesn't cause trouble in PV guest, guess
> the hypercall for MMUEXT_INVLPG_MULTI was translated or treated as
> MMUEXT_TLB_FLUSH_MULTI. If so, believe correct this will bring a big
> performance benefit.

It's not clear to me what was buggy with the code prior to your
change. And no, there's no magic widening of the scope of these
MMU operations - if you ask the hypervisor for a single page
invalidation, that's what it's going to do. But of course, there
are cases where extra (full) invalidations need to be done
without a guest asking for them. But that's nothing a guest can
validly make itself dependent upon.

Jan

