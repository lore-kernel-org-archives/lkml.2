Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0LIRSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:18:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:38408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0LIRSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:18:11 -0500
Subject: Re: [PATCH] perf_event: fix error handling path
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: jovi zhang <bookjovi@gmail.com>, Thiago Farina <tfransosi@gmail.com>,
        paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D010C9D.6020005@linux.vnet.ibm.com>
References: <1291432752-2466-1-git-send-email-bookjovi@gmail.com>
	 <AANLkTimnSPSEx+B+wgxJaaAO8-HxcnLW+Nob4O3mjxBn@mail.gmail.com>
	 <AANLkTimFjH6JZjOhPBrHmfpRycs4gDJuCpa+koxEyNgY@mail.gmail.com>
	 <AANLkTi=HGdGs++FKY6=icEs3FTwSggXTu42JQ+1MCxBc@mail.gmail.com>
	 <4D010C9D.6020005@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 18:17:57 +0100
Message-ID: <1291915077.6803.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 09:06 -0800, Corey Ashford wrote:
> On 12/07/2010 05:51 PM, jovi zhang wrote:
> > On Mon, Dec 6, 2010 at 9:59 AM, jovi zhang<bookjovi@gmail.com>  wrote:
> >> On Sun, Dec 5, 2010 at 8:29 PM, Thiago Farina<tfransosi@gmail.com>  wrote:
> >>>
> >>> On Sat, Dec 4, 2010 at 1:19 AM,<bookjovi@gmail.com>  wrote:
> >>>> fix error handling path
> >>>>
> >>>> Signed-off-by: Jovi Zhang<bookjovi@gmail.com>
> >>>>   kernel/perf_event.c |    2 --
> >>>>   1 files changed, 0 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> >>>> index cb6c0d2..62f9e9d 100644
> >>>> --- a/kernel/perf_event.c
> >>>> +++ b/kernel/perf_event.c
> >>>> @@ -1918,8 +1918,6 @@ static int get_callchain_buffers(void)
> >>>>         }
> >>>>
> >>>>         err = alloc_callchain_buffers();
> >>>> -       if (err)
> >>>> -               release_callchain_buffers();
> >>>
> >>> Care to explain in the change log message? As I reader, is not clear
> >>> to me what is wrong with this.
> >>
> >> Sorry, the description should be as:
> >> fix error handling path. alloc_callchain_buffers() can return -ENOMEM,
> >> in this time callchain_cpus_entries maybe is NULL, It will oops if
> >> invoke release_callchain_buffers() when callchain_cpus_entries is
> >> NULL.
> >>
> > I hope my understanding is right, is it?
> 
> One possible problem here is what if it returns an error other than 
> -ENOMEM, and the buffers do need to be released?  Maybe you could change 
> the code to
> 
> err = alloc_callchain_buffers();
> if (err != -ENOMEM)
> 	release_callchain_buffers();
> 
> 
> Currently, alloc_callchain_buffers cannot return any error code other 
> than -ENOMEM, but that might change in the future.

The kernel convention is to fully clean up after yourself if you return
an error. So in that sense the patch seems right.

Anyway, anybody care to post a new patch with slightly extended
changelog?
