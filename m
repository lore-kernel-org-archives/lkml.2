Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2JPJw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:52:27 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64627 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2JPJw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Vc6aPAqG7gDobjOaiSRqw8MNAG7pS3o-ze6ejXXF7AFEg@mail.gmail.com>
References: <1350377120-27657-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=n-523nC=bM9X5WrWYv=o=aKK_s-+MsA+XVcVP1yy1zFg@mail.gmail.com>
	<CAHp75Vc6aPAqG7gDobjOaiSRqw8MNAG7pS3o-ze6ejXXF7AFEg@mail.gmail.com>
Date: Tue, 16 Oct 2012 15:22:26 +0530
Message-ID: <CAKohponnT=q5bEgzdSSdPNQnskPMM0BbDdDPR3Cc+Gq5NeK-xg@mail.gmail.com>
Subject: Re: [PATCH] dmatest: terminate all ongoing transfers before
 submitting new one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Adding blank lines before and after your replies makes it more readable.

On 16 October 2012 15:05, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> On Tue, Oct 16, 2012 at 11:56 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
>> Can you try with a large timeout value for the module.
> I tried and the failures were gone.

Ok. So there is no problem with s/w emulation. Good. :)

>> We must get to the root cause of these failures. There may be something more
>> serious which is getting hidden due to this call to terminate().
> My understanding is that. The software LLP emulation runs several
> transactions per active descriptor. Because of a huge load of the
> CPU/DMA some transactions are not done within given timeout. The
> dmatest supplies next block to transfer without doing anything for
> previous one. Under some circumstances the new transfer is queued, and
> immediately after this the callback function is called for _previous_
> transfer. The check condition doesn't recognize which transfer called
> the callback function.
>
> Rough solution is proposed by current patch. Another solution is to
> mark each transfer with id and check done flag and transfer id
> together.

>> Also, the proposed solution might hide some other important errors. We may need
>> to terminate transfers when we found that an error is there in  last transfers:
> I think it could be better than first solution, but what do you think
> about marking each transfer with corresponding id?

But dma_test expects the transfer to finish within timeout. If it
doesn't, then that's
an error.

So, for testing your s/w emulation, you must pass higher timeout. And
terminating
transfers for error case would be better, to make them timeout safe.

--
viresh
