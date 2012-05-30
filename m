Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2E3Ty2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:54:28 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:43570 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2E3Ty1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205301441350.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
 <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com>
 <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org>
 <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org>
 <alpine.DEB.2.00.1205301441350.31768@router.home>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 30 May 2012 15:54:06 -0400
Message-ID: <CAHGf_=ooVunBpSdBRCnO1uOoswqxcSy7Xf8xVcgEUGA2fXdcTA@mail.gmail.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
To: Christoph Lameter <cl@linux.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 3:42 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 30 May 2012, Andi Kleen wrote:
>
>> On Wed, May 30, 2012 at 01:50:02PM -0500, Christoph Lameter wrote:
>> > On Wed, 30 May 2012, Andi Kleen wrote:
>> >
>> > > I always regretted that cpusets were no done with custom node lists.
>> > > That would have been much cleaner and also likely faster than what we have.
>> >
>> > Could shared memory policies ignore cpuset constraints?
>>
>> Only if noone uses cpusets as a "security" mechanism, just for a "soft policy"
>> Even with soft policy you could well break someone's setup.
>
> Well at least lets exempt shared memory from memory migration and memory
> policy updates. That seems to be causing many of these issues.

Yes, that's right direction, I think. Currently, shmem_set_policy() can't handle
nonlinear mapping. vma -> file offset transration is not so easy work
and I doubt
we should do.
