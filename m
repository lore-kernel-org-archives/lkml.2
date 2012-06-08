Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab2FHT4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:56:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57882 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab2FHT4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAHVUoiQ_csZeh_FEHaCkqmJvHO+Q=UF2Va7V19G-3C=xuSYTPw@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
	<CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
	<CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com>
	<CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
	<CAHVUoiSP7SiWCtYPvKS_1RuAV0upWmT06iN7PR1OE6NAtToirQ@mail.gmail.com>
	<CAH3drwY61Pqd1MXxgSYcHRPJF5pNr2FO7vrM_ULsRvMbYjAhOQ@mail.gmail.com>
	<CAHVUoiTfooPSXyVpcg_Khc0rzYcnmvAbGgfko42hOxqukc91_A@mail.gmail.com>
	<CAHVUoiT4FgEpWDLtzfTUaCTZR-rFx76E3MRdU8u9swjmt74ZQg@mail.gmail.com>
	<CAHVUoiQ_csZeh_FEHaCkqmJvHO+Q=UF2Va7V19G-3C=xuSYTPw@mail.gmail.com>
Date: Fri, 8 Jun 2012 15:56:03 -0400
Message-ID: <CAH3drwa430bUfY4ZHfn583JsDU5Sv=Y5WNaWWXm=a1XpJV1iSw@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
From: Jerome Glisse <j.glisse@gmail.com>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 6:13 AM, Brian Gitonga Marete <marete@toshnix.com> wrote:
> On Fri, Jun 8, 2012 at 12:56 AM, Brian Gitonga Marete
> <marete@toshnix.com> wrote:
>> On Fri, Jun 8, 2012 at 12:44 AM, Brian Gitonga Marete
>> <marete@toshnix.com> wrote:
>>> On Thu, Jun 7, 2012 at 11:20 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>>>> On Thu, Jun 7, 2012 at 3:59 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
>>>>> On Thu, Jun 7, 2012 at 5:25 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>>>>>>
>>>>>> Update your libdrm to libdrm from git should fix your issue.
>>>>>
>>>>> Hello Jerome,
>>>>>
>>>>> Thanks for looking into this.
>>>>>
>>>>> I am afraid that even with the very latest libdrm (git 93a5117d), the
>>>>> rendering is still broken.
>>>>>
>>>>> What else should I try? I would revert the patch that git-bisect
>>>>> fingered (your patch, git 285484e2d, Linux mainline) but there are
>>>>> merge problems when I try to do that, which I have not yet looked
>>>>> into. Perhaps you can see if you can help me revert that patch so that
>>>>> we can see if the problem then goes away?
>>>>>
>>>> What happen if you upgrade to xf86-video-ati from git ?
>>>
>>> Hello Jerome,
>>>
>>> Once again, thanks a lot for your help.
>>>
>>> Some progress but also a setback: Upgrading to the latest
>>> xf86-video-ati git gets rid of the stream command failures - No more
>>> error messages in dmesg(8). But then, now, rendering is completely
>>> messed up. Previously, it was mostly the window boundaries that were
>>> blurred/messed but now also entire windows and text so that you can't
>>> read anything from the desktop. (For example, the previous render
>>> problems would still allow me to use gnome-terminal even though its
>>> frames were completely blurred. Now the text withing gnome-terminal is
>>> also blurred/smudged)
>>>
>>
>> I should add that in this case rendering is completely messed up in
>> _both_ 3.3.x and 3.4. But the stream command failures in 3.4 go away
>> upon upgrading to the latext xf86-video-ati git HEAD.
>
> Ok. All is fixed in kernel v3.4 if I additionally upgrade Mesa to the
> latest git. Jerome, many thanks for your help on this!
>
> So to summarize, the 3.4 breakage in Ubuntu 11.04 (and probably other
> distributions released around the same time) is fixed by:
>
> a) Upgrade libdrm to latest GIT as of this writing (93a5117d5)
> b) Upgrade xf86-video-ati to latest GIT as of this writing (5888371)
> c) Upgrade mesa to latest GIT as of this writing (529476b)
>
> Now kernel 3.4 works on my laptop.
>
> Thanks!
>
> BGM.

Brian can you please test patch below on 6.14.0 ddx and old mesa (ie
revert to ubuntu mesa & ddx) and report if it fix your issue. Thanks

http://people.freedesktop.org/~glisse/0001-drm-radeon-fix-tiling-and-command-stream-checking-on.patch

Cheers,
Jerome
