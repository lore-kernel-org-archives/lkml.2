Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2JQBeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:34:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47718 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab2JQBeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:34:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com>
 <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com>
 <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
 <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com>
 <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 16 Oct 2012 21:33:55 -0400
Message-ID: <CAHGf_=oWV7dhw4jV6tvAAgjofOBOG_K1dnYHWa2=-mMsAO7-mA@mail.gmail.com>
Subject: Re: mpol_to_str revisited.
To: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 8:12 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 16 Oct 2012, KOSAKI Motohiro wrote:
>
>> >> Even though 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a itself is simple. It bring
>> >> to caller complex. That's not good and have no worth.
>> >>
>> >
>> > Before: the kernel panics, all workloads cease.
>> > After: the file shows garbage, all workloads continue.
>> >
>> > This is better, in my opinion, but at best it's only a judgment call and
>> > has no effect on anything.
>>
>> Kernel panics help to find our serious mistake.
>
> Kernel panics are not your little debugging tool to let users suffer
> through for non-fatal issues.

use after free is fatal, no doubt.

>
>> > I agree it would be better to respect the return value of mpol_to_str()
>> > since there are other possible error conditions other than a freed
>> > mempolicy, but let's not consider reverting 80de7c3138.  It is obviously
>> > not a full solution to the problem, though, and we need to serialize with
>> > task_lock().
>>
>> Sorry no. I will have to revert it.
>
> Feel free to revert anything you wish in your own tree, I couldn't care
> less.  If you try to propose it upstream, Andrew will surely ask you to
> justify the BUG(), good luck on that.

Yeah.
I'm ok just remove both BUG() and EINVAL, but current situation (i.e. ignoring
EINVAL by caller) is surely bad. So, just revert is best IMHO.


>
> I'll reply to this message with the fix that I think is best.
