Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0GWRLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:11:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab0GWRLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:11:15 -0400
Date: Fri, 23 Jul 2010 13:10:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: fweisbec@gmail.com, peterz@infradead.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: perf swallows all NMIs when registered with a user
Message-ID: <20100723171054.GS7330@redhat.com>
References: <20100722215136.GA23517@redhat.com>
 <4C48CD0D.5020201@kernel.org>
 <20100723125505.GQ7330@redhat.com>
 <4C49C66A.3000002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C49C66A.3000002@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 09:42:18AM -0700, Yinghai Lu wrote:
> On 07/23/2010 05:55 AM, Don Zickus wrote:
> > On Thu, Jul 22, 2010 at 03:58:21PM -0700, Yinghai Lu wrote:
> >> cool, with your patch and following patch i can use nmi button now with CONFIG_LOCKUP_DETECTOR defined
> >>
> >> [PATCH] x86,nmi: move unknown_nmi_panic to traps.c
> >>
> >> So we use it even LOCKUP_DETECTOR is defined.
> >>
> >> need Don's patch...
> > 
> > Thanks for the feedback Yinghai!
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > With regards to your patch, I am still a little uncomfortable with it, as
> > it seems to be redundant with what is used in unknown_nmi_error() and the
> > panic_on_unrecovered_nmi flag.  I agree that keeping the familiar flag
> > 'unknown_nmi_panic' is needed.  But I was still wondering if wrapping it
> > around 'panic_on_unrecovered_nmi' would be simpler and less code.
> 
> how about the one in sysctl?

Would it be wrong to do something like (sorry for the copy/paste):

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -744,7 +744,7 @@ static struct ctl_table kern_table[] = {
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) &&
!defined(CONFIG_LOCKUP_DETECTOR)
        {
                .procname       = "unknown_nmi_panic",
-               .data           = &unknown_nmi_panic,
+               .data           = &panic_on_unrecovered_nmi,
                .maxlen         = sizeof (int),
                .mode           = 0644,
                .proc_handler   = proc_dointvec,

Cheers,
Don

