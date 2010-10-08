Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab0JHQRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:17:31 -0400
Received: from mx1.sophos.com ([195.166.81.52]:57771 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0JHQRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:17:30 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: John Stoffel <john@stoffel.org>
Subject: Re: Linux 2.6.36-rc7
Date: Fri, 8 Oct 2010 17:17:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <1286486674.2571.16.camel@localhost.localdomain> <19631.15310.568446.991954@quad.stoffel.home>
In-Reply-To: <19631.15310.568446.991954@quad.stoffel.home>
MIME-Version: 1.0
Message-ID: <201010081717.25940.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/10/2010 17:17:26,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/10/2010 17:17:26,
	Serialize complete at 08/10/2010 17:17:26
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 Oct 2010 16:42:06 John Stoffel wrote:
> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:
> Eric> I will tell you that the way I envision it working (and being
> Eric> backwards compatible) is that priority 0 is the last thing to be
> Eric> serviced.  If 2 things register at the same priority the order
> Eric> between them getting events is unpredictable.  So when an HSM
> Eric> uses the interface it would use the highest priority.  An AV
> Eric> vendor might use (highest priority / 2) while normal inotify
> Eric> like listeners would all be happy using priority 0.
>
> Ugh, I'd prefer that priority 0 is first (highest), but I can see how
> that would make ABI problems, assuming we don't punt on releasing the
> ABI now.
>
> So if the order is undefined now, that's not good.  Well... maybe it's
> acceptable, but I can see all kinds of problems cropping up.
> Hopefully they're processed in order of notifier creation instead.  So
> if I insert a notifier, anyone who inserts a notifier after me gets
> serviced after my notifier gets run.  That would seem to be the
> logical and sane semantics to use here.
>
> Again, I'm really approaching this as a SysAdmin who'd love to use
> this in an HSM environment, so ordering is a *key* requirement.

Ordering by time of registration? I thought of that but it falls flat once any
service needs to restart or be restarted.

Priority is also not that great concept. I may have proposed classes or
something similar at some point, don't remember any more. It would be
equivalent to having allocated priority ranges, like:

>1000 - pre-content
>=100 - access-control
<100 - content

Doesn't really solve ordering inside groups so maybe we do not need priorities
at all just these three classes?

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
