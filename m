Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab2GYRcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:32:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab2GYRcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:32:06 -0400
Date: Wed, 25 Jul 2012 19:30:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 03/17] perf, x86: Add copy_from_user_nmi_nochk for best
 effort copy
Message-ID: <20120725173031.GA14996@krava.brq.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-4-git-send-email-jolsa@redhat.com>
 <20120725161150.GA1173@somewhere.redhat.com>
 <20120725171643.GF946@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725171643.GF946@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 07:16:43PM +0200, Jiri Olsa wrote:
> On Wed, Jul 25, 2012 at 06:11:53PM +0200, Frederic Weisbecker wrote:
> > On Sun, Jul 22, 2012 at 02:14:26PM +0200, Jiri Olsa wrote:
> > > Adding copy_from_user_nmi_nochk that provides the best effort
> > > copy regardless the requesting size crossing the task boundary.
> > > 
> > > This is going to be useful for stack dump we need in post
> > > DWARF CFI based unwind, where we have predefined size of
> > > the user stack to dump, and we need to store the most of
> > > the requested dump size, regardless this size is crossing
> > > the task boundary.
> > 
> > What does that imply when we cross this limit? Are we still in the
> > task stack?
> 
> We store all we could from 'stack pointer' to 'stack pointer' + dump size.
> 
> I discussed this with Oleg and we could probably find vma for the 'stack pointer'
> and check for its size and narrow the dump - maybe more complex, but probably faster
> in comparison with dumping pages we're not interested in.
> 
> thanks,
> jirka

I can send this update later together with vdso
and 'syscall regs storage' features ;)

jirka
