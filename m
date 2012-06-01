Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab2FABBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:01:34 -0400
Received: from mail.lang.hm ([64.81.33.126]:56159 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942Ab2FABBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:01:33 -0400
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 21:01:33 EDT
Date: Thu, 31 May 2012 17:45:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
In-Reply-To: <CAHGf_=r_ZMKNx+VriO6822otF=U_huj7uxoc5GM-2DEVryKxNQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1205311744280.17976@asgard.lang.hm>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org>
 <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org> <alpine.DEB.2.00.1205301441350.31768@router.home> <CAHGf_=ooVunBpSdBRCnO1uOoswqxcSy7Xf8xVcgEUGA2fXdcTA@mail.gmail.com> <20120530201042.GY27374@one.firstfloor.org>
 <CAHGf_=r_ZMKNx+VriO6822otF=U_huj7uxoc5GM-2DEVryKxNQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, KOSAKI Motohiro wrote:

> On Wed, May 30, 2012 at 4:10 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> Yes, that's right direction, I think. Currently, shmem_set_policy() can't handle
>>> nonlinear mapping.
>>
>> I've been mulling for some time to just remove non linear mappings.
>> AFAIK they were only useful on 32bit and are obsolete and could be
>> emulated with VMAs instead.
>
> I agree. It is only userful on 32bit and current enterprise users don't use
> 32bit anymore. So, I don't think emulated by vmas cause user visible issue.

I wish this was true, there are a lot of systems out there still running 
32 bit linux, even on 64 bit capible hardware. This is especially true in 
enterprises where they have either homegrown or proprietary software that 
isn't 64 bit clean.

David Lang
