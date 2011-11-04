Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab1KDReR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:34:17 -0400
Received: from thoth.sbs.de ([192.35.17.2]:19911 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab1KDReQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:34:16 -0400
Message-ID: <4EB42202.7030708@siemens.com>
Date: Fri, 04 Nov 2011 18:33:54 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>  <20111104121601.GA15206@infradead.org>  <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>  <20111104130225.GA24563@infradead.org>  <CAOJsxLG4+-Hmpt-dfa7auEs6H1RgWWwYYs=zzb8uvJg8m10_Nw@mail.gmail.com>  <4EB3F9CE.1050407@siemens.com> <1320419814.3334.45.camel@lappy>  <4EB41227.3070708@siemens.com> <1320425297.3334.53.camel@lappy>
In-Reply-To: <1320425297.3334.53.camel@lappy>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-04 17:48, Sasha Levin wrote:
> On Fri, 2011-11-04 at 17:26 +0100, Jan Kiszka wrote:
>> On 2011-11-04 16:16, Sasha Levin wrote:
>>> On Fri, 2011-11-04 at 15:42 +0100, Jan Kiszka wrote:
>>>> On 2011-11-04 14:32, Pekka Enberg wrote:
>>>>> I know you don't see the benefits of integrated code base but I as a
>>>>> developer do.
>>>>
>>>> IIRC, this discussion still lacks striking, concrete examples from the
>>>> KVM tool vs. QEMU development processes.
>>>
>>> I'll give a current example: Michael and Rusty are currently considering
>>> a change in the virtio spec (allowing MMIO config BARs - but thats
>>> irrelevant).
>>>
>>> I'll quote what Anthony said about how he sees the big picture of how
>>> this change is going to be implemented - something which we all agree
>>> with:
>>>
>>> On Thu, 2011-11-03 at 09:37 -0500, Anthony Liguori wrote:
>>>> Well, what's needed before the spec is changed is an interesting question, but I 
>>>> think the main thing is, don't commit any virtio ABI changes to vhost, QEMU, 
>>>> NKT, or the kernel until the spec for the change has been committed.
>>>>
>>>> It would be nice to have a working implementation before committing a spec 
>>>> change.  Even nicer would be to have Acked-by's a maintainer in each area affected.
>>>
>>> Which is pretty smart. Get a working implementation before we commit to
>>> a spec.
>>>
>>> Now, how would the development process look when the trees aren't
>>> integrated? You'd try to get the kernel side stabilized, then you'd do
>>> your usermode changes, go back to the kernel patches to fix bugs and
>>> things people missed, which would require in turn new patches to the
>>> usermode part, and so until you get 5-6 versions (best case) of this
>>> change in *each* tree.
>>
>> This can happen if the kernel API went totally wrong on the first run.
>> It happens, but not frequently. Or do you see many examples for this in
>> KVM's history?
> 
> A recent example is the NMI emulation fix which reached v6 for both
> trees.

Both series had problems of their own. That contributed to the number of
independent iteration. I would have stopped sending user changes after
the first rounds until the revised kernel side was accepted.

> And from what I gather it's supposed to be a smaller scale change
> than the virtio one I've mentioned before.
> 
> There are more similar examples.
> 
>>
>> I don't remember finding this particularly problematic for any of my own
>> patch sets. If the API is controversial, you usually try to get that
>> conceptually resolved instead of updating all bits over and over again.
>> Once the API is accepted, changes to the implementations become
>> independent anyway.
>>
>>>
>>> Add some technical difficulties which just make it uglier, such as
>>> having to copy over new kernel headers into the usermode tool for each
>>> new version you want to send (linux-headers/ dir in QEMU) and you get a
>>> process which is not that pretty anymore :)
>>
>> Synching headers has become trivial these days (reloading updated KVM
>> modules may take more steps ;) ).
> 
> Yup, it's a simple copy - I didn't say it was hard, I said it's ugly.

I have to install the API headers the kernel generates and then build
against it anyway (not technically, but for cleanness reasons). If that
installation is done temporarily or tracked in some separate version
control is a footnote IMHO.

> 
>>>
>>> How would it look for an integrated project? You'd be working on the
>>> same codebase, one series of patches would take care of both the kernel
>>> changes and the userspace changes, this would speed up iterations and
>>> make testing quite easier.
>>
>> I can't imagine that the ability to do a single 'make' for a change that
>> remains split nevertheless justifies merging more user land into the
>> kernel. You can always set up a meta project for this.
> 
> Thats not the only reason for the merge ofcourse, it's just one which
> you asked about.
> 
> You can do a meta project, you can't send patches out like that though -
> which makes that meaningless.

You can script a lot of things.

In fact, I was more interested in the organizational aspect of this, not
so much in tooling setups.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
