Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2H3KP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 06:15:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42971 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2H3KPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 06:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <503DFFF4.4060909@mellanox.com>
References: <503CA1A2.90104@mellanox.com>
	<alpine.DEB.2.00.1208281947100.24229@chino.kir.corp.google.com>
	<503DFFF4.4060909@mellanox.com>
Date: Thu, 30 Aug 2012 13:15:24 +0300
X-Google-Sender-Auth: 8geD-nAVZG4nMFrAXSUPiT2Xg1s
Message-ID: <CAOJsxLGT_J_SYK89-58j3cw7ef6BQxMxmLLH0Yf7hoX-4DqPWQ@mail.gmail.com>
Subject: Re: [patch v3.6] mm, slab: lock the correct nodelist after reenabling irqs
From: Pekka Enberg <penberg@kernel.org>
To: Haggai Eran <haggaie@mellanox.com>
Cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 2:41 PM, Haggai Eran <haggaie@mellanox.com> wrote:
>> Looks like a problem in 072bb0aa5e0 ("mm: sl[au]b: add knowledge of
>> PFMEMALLOC reserve pages").  cache_grow() can reenable irqs which allows
>> this to be scheduled on a different cpu, possibly with a different node.
>> So it turns out that we lock the wrong node's list_lock because we don't
>> check the new node id when irqs are disabled again.
>>
>> I doubt you can reliably reproduce this, but the following should fix the
>> issue.
> Your patch did solve the issue. Thanks!

Applied, thanks!
