Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab2ERQz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:55:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42784 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2ERQzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <4FB676E0.9070206@zytor.com>
References: <4FB67146.9080804@zytor.com>
	<CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
	<4FB676E0.9070206@zytor.com>
Date: Fri, 18 May 2012 12:55:51 -0400
Message-ID: <CA+5PVA6n5tJ4tox56ntrJ3T+KgZXnbxpYXjyc5_D9tQ7raQFHw@mail.gmail.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
From: Josh Boyer <jwboyer@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/18/2012 09:14 AM, H.J. Lu wrote:
>> On Fri, May 18, 2012 at 8:56 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> I need an urgent opinion.  It seems we have an epic mess on our hands.
>>>
>>> GNU ld 2.22.52.0.1 silently changed the semantics of section-relative
>>> symbols that are part of otherwise empty sections, and silently changes
>>> them to absolute.  We rely on section-relative symbols staying
>>> section-relative, and actually have several sections in the linker
>>> script solely for this purpose.
>>
>> That is I talked to you a couple days ago:
>>
>> http://sourceware.org/bugzilla/show_bug.cgi?id=14052
>>
>
> I know, which was a very good thing... otherwise we'd probably not have
> tracked this down anywhere near as quickly.  Thank you.
>
> The problem is that this version of binutils made it into Fedora 17, and
> so we now have a large number of users with a known bad binutils in the
> field...

We've not seen many kernel bugs that would seem to be blamed on this as
of yet.  It does seem like a problem waiting to hit us once F17 goes GA
though.  My limited 32-bit F17 machine collection definitely shows the
__init_{begin,end} symbols being absolute, but they boot fine.  Likely
because the kernel isn't relocated on them.

For what it's worth, I've filed a bug against Fedora binutils here:
https://bugzilla.redhat.com/show_bug.cgi?id=822981

josh
