Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1DZUhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab1DZUhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:37:47 -0400
Date: Tue, 26 Apr 2011 22:36:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [PATCH 0/1] tile: do_hardwall_trap: do not play with task->sighand
Message-ID: <20110426203644.GA10177@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-3-git-send-email-matt@console-pimps.org> <20110413194231.GA15330@redhat.com> <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com> <20110414190012.GA23517@redhat.com> <20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com> <20110418164513.GA25930@redhat.com> <20110421190332.GA2570@redhat.com> <4DB17CDE.3050603@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB17CDE.3050603@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Chris Metcalf wrote:
>
> On 4/21/2011 9:03 PM, Oleg Nesterov wrote:
> > Hmm. It turns out, I can't make the patch because I do not understand
> > what this code tries to do.
> >
> > hardwall_activate() adds the thread to hardwall_list, but do_hardwall_trap()
> > sends the signal to the whole process. I know nothing about arch/tile and
> > probably this is correct, but could you confirm this?
>
> Yes, the intended behavior is to send the signal to the process, as a way
> of indicating the OS's displeasure with sending a malformed packet on the
> user network.  But I think sending it to the specific thread is reasonable
> too; I don't have a strong preference in this design.
>
> > Note that SIGILL can be delivered to another thread in the thread-group, is
> > it correct?
> >
> > Also. Is it supposed that SIGILL can have a hanlder or can be blocked, or
> > it should always kill the whole thread group?
>
> A handler would be reasonable for the process.

OK. In this case the thread-specific SIGILL makes more sense afaics.

> > I think we need the patch below, assuming that SIGILL should be sent to
> > the single thread and it is fine to have a handler for SIGILL.
>
> Thanks; I appreciate the additional code review in any case.  I'll look at
> the ramifications of the change in more detail when I return from vacation
> late next week.

Great. I am sending the same patch + the changelog.

Please do not forget, I know _nothing_ about arch/tile, and of course the
patch was not tested.

Oleg.

