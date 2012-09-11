Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab2IKS6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:58:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33660 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab2IKS6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120911184553.GT7677@google.com>
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
	<20120911184553.GT7677@google.com>
Date: Tue, 11 Sep 2012 11:58:05 -0700
Message-ID: <CAFR8uefj7kxNUHLeppsH8THPzM7XCzT3tOxtuZ0qr4XUe7Bbmw@mail.gmail.com>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, david@fromorbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:45 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Sep 11, 2012 at 11:36:28AM -0700, Muthu Kumar wrote:
>> Does this preserve the CPU from which the bio was submitted
>> originally. Not familiar with cmwq, may be Tejun can clarify.
>>
>> Tejun - the question is, do we honor the rq_affinity with the above
>> rescue worker implementation?
>
> The work item would run from the same CPU but there isn't any
> mechanism to keep track of the issuing CPU if there are multiple bios
> to be rescued.  Isn't rq_affinity an optimization hint?  If so, I
> don't think it matters here.
>

Thanks... Just worried about performance impact.

Kent - Anything to validate that the performance is not impacted would
be really good. Otherwise, the patch looks great.

Feel free to add:

Reviewed-by: Muthukumar Ratty <muthur@gmail.com>


Regards,
Muthu


> Thanks.
>
> --
> tejun
