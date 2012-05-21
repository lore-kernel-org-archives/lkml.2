Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab2EUUSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:18:44 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:27835 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752999Ab2EUUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:18:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8lzW_8wVM1lOKZp8.5NDjUbawnkVCc2WIv5isfzrcgWj7z.
 Mna2nfwWoidvxNJV3mdkeLGLtgal79CkfeZ9Fls8lroMh4Xd0cOkTEaApxje
 QD2CJND0fGicvly6VMqCRISf7l28cuoqIt5eTPnSLWCZEQgL74XTQ.NsjUdE
 .VWh66kyFe5ozfZopNE7Yo03RkzhqBG7d8Yq3xZmXwvgO4NEShDK7F17gLMC
 Wii..yVYd77qkPqw_Gj.6J8vxgS5ZcREdaxCljW9ELzq3Tc13R.1FZlvSXW8
 616VBqtZn_fgLR2qabB80Kt.K0QsHZird6Of1yR4.yZFBaPLEjP9WQj5Ypij
 MVKFbWYHtYF6MMPvtg.r3Y1x4Rl9Z1MjihCeARCmb4eIuSdGLyJeMKIK52kq
 RRgIX9XTHvCcVfR_ltVm2km1xoJFFyMhzwvZR
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 May 2012 15:18:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
In-Reply-To: <20120521200118.GA12123@redhat.com>
Message-ID: <alpine.DEB.2.00.1205211510480.10940@router.home>
References: <20120517213120.GA12329@redhat.com> <20120518185851.GA5728@redhat.com> <20120521154709.GA8697@redhat.com> <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com> <20120521200118.GA12123@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Dave Jones wrote:

> On Mon, May 21, 2012 at 12:39:19PM -0700, Linus Torvalds wrote:
>
>  > But there's not a lot of recent stuff. The thing that jumps out is Mel
>  > Gorman's recent commit cc9a6c8776615 ("cpuset: mm: reduce large
>  > amounts of memory barrier related damage v3"), which has a whole new
>  > loop with that scary mpol_cond_put() usage. And there's we had
>  > problems with vma merging..
>  >
>  > Dave, how recent is this problem? Have you already tried older kernels?
>
> I tried bisecting, but couldn't find a 'good' kernel.
> I Went back as far as 3.0, before that I kept running into compile failures.
> Newer gcc/binutils really seems to dislike 2.6.x now.

Well binary distro kernels are available that allow easy testing. Will try
with what I got here. I have reproduced it with 3.4 so far.

Its always an mput on a freed memory policy. Slub recovery keeps my system
up at least. I just get the errors dumped to dmesg.

Is there any way to get the trinity tool to stop when the kernel writes
errors to dmesg? That way I could see the parameters passed to mbind?



