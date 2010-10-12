Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0JLGE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:04:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:44697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0JLGE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:04:57 -0400
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286844650.7768.137.camel@yhuang-dev>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	 <1286606987-19879-3-git-send-email-ying.huang@intel.com>
	 <1286813635.2336.617.camel@twins>  <1286844650.7768.137.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 08:04:39 +0200
Message-ID: <1286863479.2336.1451.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 08:50 +0800, Huang Ying wrote:
> On Tue, 2010-10-12 at 00:13 +0800, Peter Zijlstra wrote:
> > On Sat, 2010-10-09 at 14:49 +0800, Huang Ying wrote:
> > > notify_die(DIE_NMI_IPI);
> > > notify_die(DIE_NMI);
> > > /* process io port 0x61 */
> > > nmi_watchdog_touch();
> > > unknown_nmi(); 
> > 
> > Why keep NMI_IPI? What the heck is it for?
> 
> DIE_NMI_IPI is used for CPU-specific or CPU-local NMIs, such as perf
> NMI. While DIE_NMI is used for non-CPU-specific or global NMIs, such as
> NMI notification from source bridge.
> 
> The order between these two is important. So we use two die value to
> enforce the order.

But you can't know about that, there is no reason field to distinguish
between these cases, so you might as well fold it into a single notifier
chain and be done with it.

There is no good reason to call two chains when one is enough.

Also, the IPI name is terrible, its not IPI related at all. Please kill
the thing.
