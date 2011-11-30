Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1K3Joe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:44:34 -0500
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:58191 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab1K3Job (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:44:31 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: what's the replace for the big kernel lock after kernel version 2.6.39 for system call.
Date: Wed, 30 Nov 2011 09:44:27 +0000
User-Agent: KMail/1.13.7 (Linux/3.1.0-1.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Wen Yan Xin <WenYan_Xin@symantec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zongliang Li <Zongliang_Li@symantec.com>,
        Gang He <Gang_He@symantec.com>,
        Yong Jun Chai <YongJun_Chai@symantec.com>
References: <S1752501Ab1KYJXy/20111125092354Z+1871@vger.kernel.org> <F0BE05962279964D949D53875492E2E24FC27D7C30@APJ1XCHEVSPIN32.SYMC.SYMANTEC.COM> <20111129214136.GR2203@ZenIV.linux.org.uk>
In-Reply-To: <20111129214136.GR2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111300944.27607.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 Nov 2011 21:41:36 Al Viro wrote:
> On Mon, Nov 28, 2011 at 01:03:07AM -0800, Wen Yan Xin wrote:
> > Hi all,
> > 
> > I have a trouble of working on kernel 2.6.39 and later. Originally when
> > our kernel module startups, it hooks some file system call, like
> > sys_open... , and the big kernel lock - lock_kernel() - will be held
> > before creating the hook to prevent user application use system calls,
> > and be released after the hook created.
> > 
> > 
> > But after the kernel 2.6.39, the big kernel lock has been removed. I'm
> > thinking there should be one or more lock that should be used.
> > 
> > So, my question is which lock should be held now, when we hook the system
> > call of file system?
> > 
> > I'd really appreciate your answer in advance.
> 
> 1) your rootkit has always been racy; taking BKL does *NOT* prevent another
> CPU from entering a system call.
> 
> 2) none; just don't do it.

Hi Al,

Why not be a nice guy when you already took the effort of replying and mention 
fanotify? Because I am sure you know the history and when you see a security 
vendor asking these things, you never know, maybe it fits their requirements. 
Maybe it is not your favourite thing as well, but not a reason not to mention 
it.

And strictly speaking, rootkits actively try to hide themselves hence whatever 
unsafe, ugly and wrong stuff they might have it is not a rootkit. :)

Regards,

Tvrtko
