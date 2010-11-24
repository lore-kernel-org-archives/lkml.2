Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0KXAYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:24:21 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49477 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0KXAYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:24:19 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=RoojVSJIJluF7nPEL/ZfEjhFDjN56szB521nsKvm9G4= c=1 sm=1
 a=btxqJe0AtA4A:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=nRwU3XthOO4widYwk5kA:9
 a=WQzpwrhdvFobJt0L80wA:7 a=snMbXiUwh9dsWbC0-Z4iGcKaJdcA:4 a=CjuIK1q_8ugA:10
 a=O7oyfJTqP5OdwHuS:21 a=2DmWBsvlc4SAkNsI:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20101123121840.e9d17d91.akpm@linux-foundation.org>
Date: Tue, 23 Nov 2010 17:24:17 -0700
Cc: wharms@bfs.de, =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8B057A3D-D1D5-4875-8A0D-45C9223CD1D7@dilger.ca>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com> <20101112120834.33062900.akpm@linux-foundation.org> <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack> <4CEBD37E.5060107@bfs.de> <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca> <20101123121840.e9d17d91.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-23, at 13:18, Andrew Morton wrote:
> On Tue, 23 Nov 2010 11:02:44 -0700
> Andreas Dilger <adilger.kernel@dilger.ca> wrote:
> 
>> On 2010-11-23, at 07:45, walter harms wrote:
>>> Maybe we can convince the gcc people to make 0 padding default. That will not solve the problems for other compilers but when they claim "works like gcc" we can press then to support this also. I can imagine that this will close some other subtle leaks also.
>> 
>> It makes the most sense to tackle this at the GCC level, since the added overhead of doing memset(0) on the whole struct may be non-trivial for commonly-used and/or large structures.
> 
> We can't reasonably address this with gcc changes.  If gcc starts doing
> what we want in the next release, how long will it be until that
> release is the *oldest* version of gcc which the kernel may be compiled
> with?  Five years?

At the same time, we've had these same issues for 15+ years already, and IMHO I don't think anyone can extract a great deal of "information" from 4 bytes of random data interspersed in the middle of some structure that is otherwise initialized or zeroed out by the compiler.

On the other hand, calling memset() on these structures imposes a (virtually) permanent overhead on all processing of those structures.


If people are genuinely concerned about this kind of "information leak", a far better solution would be to add explicit padding fields to the structures (that are otherwise never going to be used) and then GCC will automatically initialize them without the overhead of initializing the fields twice.

Cheers, Andreas





