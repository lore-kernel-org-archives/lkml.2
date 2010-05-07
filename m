Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab0EGMh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:37:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:33433 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0EGMh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:37:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WjR86GG51AW6LC5gcMSQsloGxqrPYiVy0L4e4i6WzwfhHq9TOZ+tVSeKEq17ItaFb
	dZyqs980FYQC6MVgUhPUw==
MIME-Version: 1.0
In-Reply-To: <20100507122520.GD21498@rakim.wolfsonmicro.main>
References: <20100505185225.GA4411@srcf.ucam.org>
	 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
	 <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com>
	 <20100505234025.GB4838@opensource.wolfsonmicro.com>
	 <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com>
	 <20100507100406.GA21498@rakim.wolfsonmicro.main>
	 <w2kd6200be21005070357r9aad2896l355168a23bf85eae@mail.gmail.com>
	 <20100507112102.GC21498@rakim.wolfsonmicro.main>
	 <81818215-44A2-4B74-A43F-E2644C950F5C@mit.edu>
	 <20100507122520.GD21498@rakim.wolfsonmicro.main>
Date: Fri, 7 May 2010 05:37:21 -0700
Message-ID: <z2wa55d774e1005070537k8e3cb6baxc74e998e930d254d@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Theodore Tso <tytso@mit.edu>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 5:25 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, May 07, 2010 at 07:29:47AM -0400, Theodore Tso wrote:
>
>> This sounds like it may be something unique to your board/product.  Or
>> am I missing something?
>
> I suspect you're missing something here - I'm approaching this as one of
> the maintainers of the embedded audio subsystem for the kernel.  I need
> to worry about any system running Linux which has an embedded style
> audio subsystem.  The problem might be unique to audio, but I can't say
> that for certain.
>
>> One of the challenges with PM in the embedded world is that everybody
>> seems to have slightly different assumptions, and hardware that doesn't
>> behave the same way.
>
> This isn't really a problem for audio - we've already got a subsystem
> which copes well with pretty much all systems and does runtime PM that's
> equivalent to suspending already, which is half the problem here.  If we
> had less generalisation this would probably not have come up.
>
>> More than once this discussion has wandered off into the weeds wrt to
>> whether this patch series is ready to be merged, since there are so many
>> drivers blocked on it....
>
> Once more, my main objective here has been to make sure that when this
> is merged we've got a joined up story about how people think this hangs
> together, which I think we have now.  As I say now that we have that
> understanding I don't see any reason to block merge.
>
> It's unfortunate that I only noticed that this was actually wakelocks
> very late in the day but I think I can get an implementation which
> handles paths that ignore suspends done quickly.

Do you mean an implementation of embedded linux audio or an
implementation of suspend blockers "which handles paths that ignore
suspends"?  I assume you mean the former, but maybe I misunderstand.

We've done a lot of work around multicore SoCs where the baseband
generally owns a lot of the audio routing and so on, but we do as
general policy not disable audio, codecs, and amps while playback or
record is underway.  I suppose for environments more like a pc laptop
where the expectation is the world stops when you close the lid a
different policy would be preferable.

We typically fire up codecs and amps when playback starts (if they
were off), and usually set a timer for a couple seconds after playback
stops to spin them down (since you tend to have to delay while they're
powering up to avoid pops, etc, and if the system just played a short
sound there's a reasonable chance it'll follow that with another).

Apologies about the name confusion -- last year when we first started
pushing these patches out there was much dislike for the name wakelock
and after a lot of back and forth suspend_block ended up as the least
hated of the suggested alternatives (I kinda like "wakelock" as a
name, but maybe that's just brain rot after dealing with 'em for four
years now).

Brian
