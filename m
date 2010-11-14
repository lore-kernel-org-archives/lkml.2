Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0KNHOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 02:14:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46027 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0KNHOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 02:14:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1][2nd resend] sys_unshare: remove the dead CLONE_THREAD/SIGHAND/VM code
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Roland McGrath <roland@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        JANAK DESAI <janak@us.ibm.com>
In-Reply-To: <20101109171754.GB6971@redhat.com>
References: <20101109201742.BCA1.A69D9226@jp.fujitsu.com> <20101109171754.GB6971@redhat.com>
Message-Id: <20101114161354.BEDB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 16:14:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/09, KOSAKI Motohiro wrote:
> >
> > > -static void check_unshare_flags(unsigned long *flags_ptr)
> > > +static int check_unshare_flags(unsigned long unshare_flags)
> > >  {
> > > +	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
> > > +				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
> > > +				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET))
> > > +		return -EINVAL;
> >
> > Please put WARN_ON_ONCE() explicitly. That's good way to find hidden
> > user if exist and getting better bug report.
> 
> Perhaps... but this needs a separate change.
> 
> Please note that this check was simply moved from sys_unshare(), this
> patch shouldn't have any visible effect.
> 
> Personally, I think it would be even better if, say, unshare(CLONE_THREAD)
> returned -EINVAL unconditionally.

Ah, OK. you are right.



> > And, I've reveied this patch and I've found no fault. but I will not put
> > my ack because I think I haven't understand original intention perhaps.
> 
> Thanks!
> 
> IIRC, the main (only?) motivation for sys_unshare() was unshare_fs().
> Most probably unshare_thread/vm were added as placeholders.





