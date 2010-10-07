Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0JGRP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:15:58 -0400
Received: from mx3.sophos.com ([74.202.89.160]:33751 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab0JGRP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:15:56 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: Linux 2.6.36-rc7
Date: Thu, 7 Oct 2010 18:15:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <201010071710.46938.tvrtko.ursulin@sophos.com>
In-Reply-To: <201010071710.46938.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201010071815.54303.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 07/10/2010 18:15:54,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 07/10/2010 18:15:54,
	Serialize complete at 07/10/2010 18:15:54
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 Oct 2010 17:10:46 Tvrtko Ursulin wrote:
> On Wednesday 06 Oct 2010 22:45:13 Linus Torvalds wrote:
> [snip]
>
> > And yes, that's probably as exciting as it gets, which is just fine by
> > me. This should be the last -rc, I'm not seeing any reason to keep
> > delaying a real release. There was still more changes to
> > drivers/gpu/drm than I really would have hoped for, but they all look
> > harmless and good. Famous last words.
>
> Hi Linus,
>
> Please see http://marc.info/?l=linux-kernel&m=128618485204253&w=2
>
> I have sent this proposed bugfix several times now but no one is picking it
> up and Eric seems to have disappeared. It would be suboptimal to release
> 2.6.36 with a core fanotify feature non-functional.

Unfortunately I have another showstopper. Sadly I missed it until now because
internally we were more worried of issues which were kind of direct problems
for us and I went to deep instead of spending more time reviewing it breath
first.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=08ae89380a8210a9965d04083e1de78cb8bca4b1

Priority argument was dropped from the fanotify_init syscall, and since it is
a syscall once released it is set in stone. Without the priority argument, how
are multiple clients supposed to be ordered?

Co-existence between multiple clients was something which was supposed to be
designed in from the start. Use cases like hierarchical storage management,
anti-malware and content indexing should all be able to co-exist. Without a
priority argument I do not see how it can be assured HSM sees the perm event
before anti-malware, and content indexing after both of them? If there was any
discussion about dropping priority I missed it. :(

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
