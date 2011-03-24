Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab1CXSGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:06:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32858 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572Ab1CXSGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=AzrpDP/3psZVgyXbFV5HMwgm+L+xfyoj7kxxAZzNV4o/p3JkB6G5y2QsWyJ4NVfk8Z
         zyhgvHrrlYlUiutuRpVW4v+D/ABp7EFE40aIbi2SP/tZlXPwpuwYEwkI036B+yv89vA3
         tHtsTO98nW0GSegRICjPR5Ig4utUoHcYuAxno=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103241300420.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<alpine.DEB.2.00.1103240940570.32226@router.home>
	<AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	<20110324172653.GA28507@elte.hu>
	<alpine.DEB.2.00.1103241242450.32226@router.home>
	<AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
	<alpine.DEB.2.00.1103241300420.32226@router.home>
Date: Thu, 24 Mar 2011 20:06:10 +0200
X-Google-Sender-Auth: YUXc8fCmbbBXs3F6guA67D8dlfw
Message-ID: <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 8:01 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 24 Mar 2011, Pekka Enberg wrote:
>
>> On Thu, Mar 24, 2011 at 7:43 PM, Christoph Lameter <cl@linux.com> wrote:
>> > The bug should only trigger on old AMD64 boxes that do not support
>> > cmpxchg16b.
>>
>> Yup. Ingo is it possible to see /proc/cpuinfo of one of the affected
>> boxes? I'll try your config but I'm pretty sure the problem doesn't
>> trigger here. Like I said, I think the problem is that alternative
>> instructions are not patched early enough for cmpxchg16b emulation to
>> work for kmem_cache_init(). I tried my check_bugs() patch but it hangs
>> during boot. I'll see if I can cook up a patch that does
>> alternative_instructions() before kmem_cache_init() because I think
>> those *should* be available during boot too.
>
> I forced the fallback to the _emu function to occur but could not trigger
> the bug in kvm.

That's not the problem. I'm sure the fallback is just fine. What I'm
saying is that the fallback is *not patched* to kernel text on Ingo's
machines because alternative_instructions() happens late in the boot!
So the problem is that on Ingo's boxes (that presumably have old AMD
CPUs) we execute cmpxchg16b, not the fallback code.

                        Pekka
