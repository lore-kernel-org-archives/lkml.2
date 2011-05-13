Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab1EMS2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:28:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54776 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab1EMS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:28:53 -0400
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for current->comm
 references
From: John Stultz <john.stultz@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <4DCD1271.3070808@jp.fujitsu.com>
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org>
	 <1305241371-25276-4-git-send-email-john.stultz@linaro.org>
	 <4DCD1271.3070808@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 11:28:41 -0700
Message-ID: <1305311321.2680.35.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 20:13 +0900, KOSAKI Motohiro wrote:
> >   scripts/checkpatch.pl |    4 ++++
> >   1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index d867081..9d2eab5 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2868,6 +2868,10 @@ sub process {
> >   			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
> >   		}
> > 
> > +# check for current->comm usage
> > +		if ($line =~ /current->comm/) {
> > +			WARN("comm access needs to be protected. Use get_task_comm, or printk's \%ptc formatting.\n" . $herecurr);
> 
> I think we should convert all of task->comm usage. not only current. At least, you plan to remove task_lock() from
> %ptc patch later.

Yea, I'll be updating the patch to try to catch more then just
current->comm.

thanks
-john


