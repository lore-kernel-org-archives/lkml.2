Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab2HITf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:35:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50346 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab2HITfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1208031435550.25196@tundra.namei.org>
References: <744e07394a02be3d3ef52c22ccedb24d9a478fe1.1343869850.git.luto@amacapital.net>
 <alpine.LRH.2.02.1208031435550.25196@tundra.namei.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 9 Aug 2012 12:35:33 -0700
Message-ID: <CALCETrWMwnJnJ96GF=LBEVcv9BYdLEQGrpqUJZH+Gnwi2isNuQ@mail.gmail.com>
Subject: Re: [PATCH v2] seccomp: Make syscall skipping and nr changes more consistent
To: James Morris <jmorris@namei.org>
Cc: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 9:36 PM, James Morris <jmorris@namei.org> wrote:
> On Wed, 1 Aug 2012, Andy Lutomirski wrote:
>
>> This fixes two issues that could cause incompatibility between
>> kernel versions:
>>
>>  - If a tracer uses SECCOMP_RET_TRACE to select a syscall number
>>    higher than the largest known syscall, emulate the unknown
>>    vsyscall by returning -ENOSYS.  (This is unlikely to make a
>>    noticeable difference on x86-64 due to the way the system call
>>    entry works.)
>>
>>  - On x86-64 with vsyscall=emulate, skipped vsyscalls were buggy.
>>
>> This updates the documentation accordingly.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> Acked-by: Will Drewry <wad@chromium.org>
>
> Please rebase this to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next
>
> or wait until the next -rc, where I'll sync with Linus.
>

The conflict is because Linus has a partial fix for the same problem
that went in very late for 3.5, which isn't in your tree.  My patch
applies cleanly to 3.6.0-rc1 and to the result of merging your tree
with 3.6.0-rc1.

The relevant upstream changes are
5651721edec25bf73cee060150e684044eac42dc and
09d314425f5bc69fcf793c7890d9e6a3cdcb44be.

If it helps, I can stick the patch into git.

--Andy
