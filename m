Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab2FGOZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:25:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45193 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2FGOZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:25:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
	<CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
	<CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com>
Date: Thu, 7 Jun 2012 10:25:02 -0400
Message-ID: <CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
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

On Wed, Jun 6, 2012 at 7:01 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
> On Thu, Jun 7, 2012 at 1:59 AM, Brian Gitonga Marete <marete@toshnix.com> wrote:
>> On Sun, Jun 3, 2012 at 8:26 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
>>> Hello,
>>>
>>> 3.4 breaks rendering on my Radeon evergreen card. Immediately after
>>> logging in into the desktop, I get the following errors in the kernel
>>> log:
>>>
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>>> small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
>>> 575)
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>>> surf: (192 192) (0 4 1 0 0 0 0)
>>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>>> small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
>>> 575)
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>>> surf: (192 192) (0 4 1 0 0 0 0)
>>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>>> small (layer size 798720, offset 0, max layer 1, bo size 794624, slice
>>> 3119)
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>>> surf: (384 520) (0 4 1 0 0 0 0)
>>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>>> small (layer size 458752, offset 0, max layer 1, bo size 446464, slice
>>> 1791)
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>>> surf: (512 224) (0 4 1 0 0 0 0)
>>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 7170
>>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>>> small (layer size 798720, offset 0, max layer 1, bo size 790528, slice
>>> 3119)
>>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>>> surf: (384 520) (0 4 1 0 0 0 0)
>>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>>>
>>> Meanwhile, windows on the desktop are rendered incorrectly (with
>>> certain regions covered by strange patterns or smudged) or not at all.
>>> This makes the desktop unusable.
>>>
>>> I can always reproduce this problem on 3.4
>>>
>>> Kernels prior to 3.4 work fine.
>>>
>>> I will try and find the time to bisect this issue but meanwhile here
>>> are some further details:
>>>
>>
>> I have git-bisected this to find that the first bad commit is:
>> 285484e2d55 - drm/radeon: add support for evergreen/ni tiling
>> informations v11.
>>
>> So I have also added Jerome to the CC list. Please see the attached
>> bisect.log for the git-bisect log.
>
> Sorry, forgot to attach. Now attached.
>
> --
> Brian Gitonga Marete
> Toshnix Systems - http://toshnix.com

Update your libdrm to libdrm from git should fix your issue.

Cheers,
Jerome
