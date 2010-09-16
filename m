Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0IPRmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:42:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:59612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0IPRmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:42:45 -0400
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
In-Reply-To: <20100910155659.GD13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop> <20100910132741.GB4879@redhat.com>
	 <20100910144634.GA1060@elte.hu>  <20100910155659.GD13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Sep 2010 19:42:30 +0200
Message-ID: <1284658950.2275.591.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 17:56 +0200, Robert Richter wrote:
> The commit:
> 
>  e40b172 x86: Move notify_die from nmi.c to traps.c
> 
> moved the nmi handler call to default_do_nmi(). DIE_NMI_IPI and
> DIE_NMI are called subsequently now. If the return code is
> !NOTIFY_STOP, then the handlers are called twice. This patch fixes
> this. 

What is this NMI_IPI thing, and why do we bother?

If the hardware reason thin can discriminate between IPI and other NMIs
we should never call both chains, if it cannot, why do we have 2 chains?

In any case, I don't think perf/oprofile/etc,. should use NMI_IPI, that
doesn't really make sense.

Or am I totally confused about things here?
