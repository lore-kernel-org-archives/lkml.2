Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750884Ab2HYERX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 00:17:23 -0400
Received: from [216.32.180.185] ([216.32.180.185]:56393 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab2HYERV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 00:17:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI9371I1432I179dNzz1202hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M9AMI5-02-1W6-02
X-M-MSG: 
Date: Fri, 24 Aug 2012 23:15:42 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Dave Young <dyoung@redhat.com>,
        Chao Wang <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120825041542.GB26127@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-2-git-send-email-jacob.shin@amd.com>
 <CAE9FiQVugSnpVjbYLScXUNfXqmUBD54FkAuvm7TWThGYrSVLMA@mail.gmail.com>
 <CAE9FiQUyoDmpQ96OPY-9Lvq4sqHP2h=O_knkVqbpLaX6BKJRhQ@mail.gmail.com>
 <CAE9FiQUddNjpwQjs7ccURf_gKtr=-u5BNLcsxnwo+=KF+g1UAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQUddNjpwQjs7ccURf_gKtr=-u5BNLcsxnwo+=KF+g1UAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 07:06:42PM -0700, Yinghai Lu wrote:
> On Fri, Aug 24, 2012 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Aug 24, 2012 at 6:25 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> On Fri, Aug 24, 2012 at 4:55 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> >>> Depending on the platform, init_memory_mapping() may be called multiple
> >>> times. Move it out to setup_arch() to avoid writing to cr4 on every call.
> >>>
> >>> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> >>> ---
> >>>  arch/x86/kernel/setup.c |   10 ++++++++++
> >>>  arch/x86/mm/init.c      |   10 ----------
> >>>  2 files changed, 10 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> >>> index f4b9b80..751e020 100644
> >>> --- a/arch/x86/kernel/setup.c
> >>> +++ b/arch/x86/kernel/setup.c
> >>> @@ -913,6 +913,16 @@ void __init setup_arch(char **cmdline_p)
> >>>
> >>>         init_gbpages();
> >>>
> >>> +       /* Enable PSE if available */
> >>> +       if (cpu_has_pse)
> >>> +               set_in_cr4(X86_CR4_PSE);
> >>> +
> >>> +       /* Enable PGE if available */
> >>> +       if (cpu_has_pge) {
> >>> +               set_in_cr4(X86_CR4_PGE);
> >>> +               __supported_pte_mask |= _PAGE_GLOBAL;
> >>> +       }
> >>> +
> >>
> >> please don't put it directly in setup_arch().
> >>
> >> and another function.
> >>
> >
> > Jacob, hpa
> >
> > can you use attached one to replace the first patch?
> 
> Please use attached two instead.

Hmm .. okay I'll test with these two patches applied on Monday ..

> 
> Thanks
> 
> Yinghai




