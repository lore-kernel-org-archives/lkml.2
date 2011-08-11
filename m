Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1HKK6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:58:36 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40699 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751821Ab1HKK6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:58:31 -0400
Date: Thu, 11 Aug 2011 05:58:29 -0500
From: Robin Holt <holt@sgi.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Jack Steiner <steiner@sgi.com>,
        mike travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia@diku.dk>
Subject: Re: Missing put_cpu() in arch/ia64/sn/kernel/sn2/sn_hwperf.c?
Message-ID: <20110811105829.GA11879@sgi.com>
References: <1312826703.5589.155.camel@localhost.localdomain>
 <CA+8MBbJDLrNHD0kGdYNv1WPnRh8G1aEY-T3xcS_wMpciTVcy7A@mail.gmail.com>
 <4E4372DD.6020603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4372DD.6020603@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 08:12:45AM +0200, Jes Sorensen wrote:
> On 08/08/11 23:37, Tony Luck wrote:
> > On Mon, Aug 8, 2011 at 11:05 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
> >> The function sn_hwperf_op_cpu() seems to miss a corresponding put_cpu().
> >>
> >> Or is this done in another function? I didn't find it.
> > 
> > It would be hard to do it elsewhere - this function may not have done
> > a get_cpu() [in the cpu == SN_HWPERF_ARG_ANY_CPU case].
> > 
> > The logic is a bit tortuous here ... perhaps simpler to split the tests
> > up.  Does the attached patch look right?
> 
> Hi Tony,
> 
> You probably want someone from SGI to look at it, so I'll forward to
> Robin Holt.
> 
> I haven't been at SGI for about 2 years now :)

And I will bounce the question on to Jack.  I believe he will probably
pass it on to somebody more familiar with sn_hwperf.  Tony's patch looks
much clearer to me.  I would have answered that I thought this was the
right patch until I saw the '... else { put_cpu(); ...' which made me
think we need a closer look.

Thanks,
Robin
