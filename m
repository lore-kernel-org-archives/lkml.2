Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab2IKSqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:46:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2IKSp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:45:58 -0400
Date: Tue, 11 Sep 2012 11:45:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120911184553.GT7677@google.com>
References: <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <CAFR8ued=Le4B4i_Rf4eECXsVgKvce9J7bO9sDSS91PFzBZ6j5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFR8ued=Le4B4i_Rf4eECXsVgKvce9J7bO9sDSS91PFzBZ6j5w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 11, 2012 at 11:36:28AM -0700, Muthu Kumar wrote:
> Does this preserve the CPU from which the bio was submitted
> originally. Not familiar with cmwq, may be Tejun can clarify.
> 
> Tejun - the question is, do we honor the rq_affinity with the above
> rescue worker implementation?

The work item would run from the same CPU but there isn't any
mechanism to keep track of the issuing CPU if there are multiple bios
to be rescued.  Isn't rq_affinity an optimization hint?  If so, I
don't think it matters here.

Thanks.

-- 
tejun
