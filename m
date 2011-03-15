Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1COQwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:52:31 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39857 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab1COQw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:52:29 -0400
Date: Tue, 15 Mar 2011 22:22:19 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be
 overridden
Message-ID: <20110315165219.GA22509@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
References: <20100825002258.GD28360@kryten>
 <m139u37cii.fsf@fess.ebiederm.org>
 <4D771EE6.5050404@linux.vnet.ibm.com>
 <20110309122046.GC16951@cr0.redhat.com>
 <20110309234657.264d3080@kryten>
 <20110309142108.GD16951@cr0.redhat.com>
 <20110314181315.GA16075@in.ibm.com>
 <AANLkTi=aDzCaa7_=5XTrnJCzmZPrDy3omXwDarEF8XmH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=aDzCaa7_=5XTrnJCzmZPrDy3omXwDarEF8XmH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 03:52:38PM +0800, Américo Wang wrote:
> On Tue, Mar 15, 2011 at 2:13 AM, Mahesh J Salgaonkar
> <mahesh@linux.vnet.ibm.com> wrote:
> >
> > During free we do free all of them including RMO region. But since the rtas
> > region is always on top of RMO, crashkernel memory overlaps rtas region and
> > we endup freeing that even, which is causing the crash.
> >
> 
> Okay, but with this patch applied, we will just ignore rtas region, right?
Correct.
> Thus, when I echo 0 to free all the 128M crashkernel memory, the final
> result will be 32M left, which means crash_size will still show 32M.
> This looks odd.
> 
> How about skipping the 32M as a whole? I mean once the region being freed
> has overlap with this rtas region, skip the whole rtas region, and let
> crash_size
> show 0?
The existing code from crash_shrink_memory() function reduces the crash
size to 0 when echo'ed 0. I did test this patchset and verified that
/sys/kernel/kexec_crash_size show 0 value.

Thanks,
-Mahesh.
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
