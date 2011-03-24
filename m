Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab1CXEdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:33:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:48745 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab1CXEdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:33:49 -0400
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be
 overridden
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        linuxppc-dev@ozlabs.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Anton Blanchard <anton@au1.ibm.com>
In-Reply-To: <im6fj2$576$1@dough.gmane.org>
References: <20100825002258.GD28360@kryten>
	 <m139u37cii.fsf@fess.ebiederm.org> <4D771EE6.5050404@linux.vnet.ibm.com>
	 <20110309122046.GC16951@cr0.redhat.com> <20110309234657.264d3080@kryten>
	 <20110309142108.GD16951@cr0.redhat.com> <20110314181315.GA16075@in.ibm.com>
	 <AANLkTi=aDzCaa7_=5XTrnJCzmZPrDy3omXwDarEF8XmH@mail.gmail.com>
	 <20110315165219.GA22509@in.ibm.com>  <im6fj2$576$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 15:33:30 +1100
Message-ID: <1300941210.2402.414.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 03:10 +0000, WANG Cong wrote:
> On Tue, 15 Mar 2011 22:22:19 +0530, Mahesh J Salgaonkar wrote:

> >> Okay, but with this patch applied, we will just ignore rtas region,
> >> right?
> > Correct.
> >> Thus, when I echo 0 to free all the 128M crashkernel memory, the final
> >> result will be 32M left, which means crash_size will still show 32M.
> >> This looks odd.
> >> 
> >> How about skipping the 32M as a whole? I mean once the region being
> >> freed has overlap with this rtas region, skip the whole rtas region,
> >> and let crash_size
> >> show 0?
> > The existing code from crash_shrink_memory() function reduces the crash
> > size to 0 when echo'ed 0. I did test this patchset and verified that
> > /sys/kernel/kexec_crash_size show 0 value.
> 
> Oh, ok.
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

So Eric, what's the right approach to get that merged ? This is a bug
gating an important delivery for us, and the patch doesn't appear
terribly invasive ? :-)

I can send it to Linus myself if you prefer and give me your Ack.

Cheers,
Ben.


