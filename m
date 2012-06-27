Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab2F0P0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:26:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:55504 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab2F0P0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:26:04 -0400
Message-ID: <1340810729.10063.66.camel@twins>
Subject: Re: [PATCH 03/23] perf: Add ability to attach user level registers
 dump to sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 27 Jun 2012 17:25:29 +0200
In-Reply-To: <20120627152359.GI20638@somewhere.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
	 <1340120894-9465-4-git-send-email-jolsa@redhat.com>
	 <20120627151059.GG20638@somewhere.redhat.com>
	 <CABPqkBTdL7rt4YF1SYdo4N7BaK3TOvXJqfs3Te2Asmm_-jA_Ag@mail.gmail.com>
	 <20120627152359.GI20638@somewhere.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 17:24 +0200, Frederic Weisbecker wrote:
> On Wed, Jun 27, 2012 at 05:13:44PM +0200, Stephane Eranian wrote:
> > On Wed, Jun 27, 2012 at 5:11 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > On Tue, Jun 19, 2012 at 05:47:54PM +0200, Jiri Olsa wrote:
> > >> @@ -4061,6 +4105,19 @@ void perf_prepare_sample(struct perf_event_header *header,
> > >>               }
> > >>               header->size += size;
> > >>       }
> > >> +
> > >> +     if (sample_type & PERF_SAMPLE_REGS_USER) {
> > >> +             /* regs dump available bool */
> > >> +             int size = sizeof(u64);
> > >> +
> > >> +             data->regs_user = perf_sample_regs_user(regs);
> > >> +             if (data->regs_user) {
> > >> +                     u64 mask = event->attr.sample_regs_user;
> > >> +                     size += hweight64(mask) * sizeof(u64);
> > >> +             }
> > >> +
> > >> +             header->size += size;
> > >
> > > We'll need to remove the 64 bits registers for compat tasks but other than
> > > that, it looks ok.
> > You cannot do this. You cannot remove register values from under the hood.
> > The only way the user has to parse the sample is the sample_regs_users bitmask.
> > You have to return 0 for those unexisting regs for compat tasks.
> 
> You mean fill unexisting reg values with 0? Yeah that works.

What does x32 look like? Is that still reported as a compat task? If so,
we should record all registers and not 0 out anything.
