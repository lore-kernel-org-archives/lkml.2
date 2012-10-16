Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2JPI4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:56:54 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64931 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2JPI4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:56:53 -0400
MIME-Version: 1.0
In-Reply-To: <1350377120-27657-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350377120-27657-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 16 Oct 2012 14:26:52 +0530
X-Google-Sender-Auth: XWY1-_ACWeXlDpJ_TRfooT5XwcA
Message-ID: <CAOh2x=n-523nC=bM9X5WrWYv=o=aKK_s-+MsA+XVcVP1yy1zFg@mail.gmail.com>
Subject: Re: [PATCH] dmatest: terminate all ongoing transfers before
 submitting new one
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 2:15 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The following error messages come if we have software LLP emulation enabled and
> enough threads running.
>
> modprobe dmatest iterations=40
> [  168.048601] dmatest: Started 1 threads using dma0chan0
> [  168.054546] dmatest: Started 1 threads using dma0chan1
> [  168.060441] dmatest: Started 1 threads using dma0chan2
> [  168.066333] dmatest: Started 1 threads using dma0chan3
> [  168.072250] dmatest: Started 1 threads using dma0chan4
> [  168.078144] dmatest: Started 1 threads using dma0chan5
> [  168.084057] dmatest: Started 1 threads using dma0chan6
> [  168.089948] dmatest: Started 1 threads using dma0chan7
> [  170.032962] dma0chan1-copy0: terminating after 40 tests, 0 failures (status 0)
> [  170.041274] dma0chan0-copy0: terminating after 40 tests, 0 failures (status 0)
> [  170.597559] dma0chan2-copy0: terminating after 40 tests, 0 failures (status 0)
> [  171.085059] dma0chan7-copy0: #0: test timed out
> [  171.839710] dma0chan3-copy0: terminating after 40 tests, 0 failures (status 0)
> [  172.146071] dma0chan4-copy0: terminating after 40 tests, 0 failures (status 0)
> [  172.220802] dma0chan7-copy0: #1: got completion callback, but status is 'in progress'
> [  172.242049] dma0chan7-copy0: #2: got completion callback, but status is 'in progress'
> [  172.281063] dma0chan7-copy0: #3: got completion callback, but status is 'in progress'
> [  172.400866] dma0chan7-copy0: #4: got completion callback, but status is 'in progress'
> [  172.471799] dma0chan7-copy0: #5: got completion callback, but status is 'in progress'
> [  172.613996] dma0chan7-copy0: #6: got completion callback, but status is 'in progress'
> [  172.670286] dma0chan7-copy0: #7: got completion callback, but status is 'in progress'
> [  172.750763] dma0chan7-copy0: #8: got completion callback, but status is 'in progress'
> [  172.777452] dma0chan5-copy0: terminating after 40 tests, 0 failures (status 0)
> [  172.788740] dma0chan7-copy0: #9: got completion callback, but status is 'in progress'
> [  172.845156] dma0chan7-copy0: #10: got completion callback, but status is 'in progress'
> [  172.906593] dma0chan7-copy0: #11: got completion callback, but status is 'in progress'
> [  173.181515] dma0chan6-copy0: terminating after 40 tests, 0 failures (status 0)
> [  173.512838] dma0chan7-copy0: terminating after 40 tests, 12 failures (status 0)
>
> The patch fixes dmatest module to stop any ongoing transfer before submitting
> new one. Perhaps there is a better solution and driver logic needs to be fixed
> as well.
>
> After patch we will have
>
> modprobe dmatest iterations=50
> [   84.027375] dmatest: Started 1 threads using dma0chan0
> [   84.033282] dmatest: Started 1 threads using dma0chan1
> [   84.039182] dmatest: Started 1 threads using dma0chan2
> [   84.045089] dmatest: Started 1 threads using dma0chan3
> [   84.051003] dmatest: Started 1 threads using dma0chan4
> [   84.056916] dmatest: Started 1 threads using dma0chan5
> [   84.062828] dmatest: Started 1 threads using dma0chan6
> [   84.068714] dmatest: Started 1 threads using dma0chan7
> [   86.538284] dma0chan0-copy0: terminating after 50 tests, 0 failures (status 0)
> [   86.842221] dma0chan1-copy0: terminating after 50 tests, 0 failures (status 0)
> [   87.060460] dma0chan6-copy0: #0: test timed out
> [   87.065614] dma0chan7-copy0: #0: test timed out
> [   87.220321] dma0chan2-copy0: terminating after 50 tests, 0 failures (status 0)
> [   88.595061] dma0chan3-copy0: terminating after 50 tests, 0 failures (status 0)
> [   89.152170] dma0chan4-copy0: terminating after 50 tests, 0 failures (status 0)
> [   89.955059] dma0chan5-copy0: terminating after 50 tests, 0 failures (status 0)
> [   90.697073] dma0chan6-copy0: terminating after 50 tests, 1 failures (status 0)
> [   90.893422] dma0chan7-copy0: terminating after 50 tests, 1 failures (status 0)

You still have failures. :(
Can you try with a large timeout value for the module.

We must get to the root cause of these failures. There may be something more
serious which is getting hidden due to this call to terminate().

Unless there is a issue with software emulation of LLP, the only difference with
s/w emulation is the transfers become slow.

Also, the proposed solution might hide some other important errors. We may need
to terminate transfers when we found that an error is there in  last transfers:

		if (!done.done) {
			/*
			 * We're leaving the timed out dma operation with
			 * dangling pointer to done_wait.  To make this
			 * correct, we'll need to allocate wait_done for
			 * each test iteration and perform "who's gonna
			 * free it this time?" dancing.  For now, just
			 * leave it dangling.
			 */
			pr_warning("%s: #%u: test timed out\n",
				   thread_name, total_tests - 1);
			failed_tests++;
			continue;
		} else if (status != DMA_SUCCESS) {
			pr_warning("%s: #%u: got completion callback,"
				   " but status is \'%s\'\n",
				   thread_name, total_tests - 1,
				   status == DMA_ERROR ? "error" : "in progress");
			failed_tests++;
			continue;
		}



--
viresh
