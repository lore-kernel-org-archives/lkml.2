Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1CHBbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:31:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57657 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab1CHBbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:31:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <20110204150047.GC32190@redhat.com>
References: <20110203141850.93C2.A69D9226@jp.fujitsu.com> <20110204150047.GC32190@redhat.com>
Message-Id: <20110308102741.7E9C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 10:31:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry I've missed this mail long time.

> > ---------------------------------------------------------------------
> > @@ -74,6 +75,7 @@ NORET_TYPE void panic(const char * fmt, ...)
> >         dump_stack();
> >  #endif
> > 
> > +       kmsg_dump(KMSG_DUMP_PANIC);
> >         /*
> >          * If we have crashed and we have a crash kernel loaded let it handle
> >          * everything else.
> >          * Do we want to call this before we try to display a message?
> >          */
> >         crash_kexec(NULL);
> > ---------------------------------------------------------------------
> 
> And I think to compensate for that somebody introduced additional
> kmsg_dump(KEXEC) call inside crash_kexec() and put it under CONFIG
> option so that one can change the behavior based on config options.
> 
> I think this makes the logic somewhat twisted and an unnecessary call
> inside crash_kexec(). So until and unless there is a strong reason we
> can get rid of KEXEC event and move kmsg_dump call before crash_kexec()
> for now and see how does it go, IMHO.

I think I can agree your proposal. But could you please explain why do
you think kmsg _before_ kdump and kmsg _in_ kdump are so different?
I think it is only C level difference. CPU don't care C function and
anyway the kernel call kmsg_dump() because invoke second kernel even 
if you proposal applied.

It is only curious. I'm not against your proposal.

Thanks.



