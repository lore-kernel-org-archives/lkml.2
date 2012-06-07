Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2FGQWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:22:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38762 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2FGQWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:22:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAL1RGDXotXpZXUeR6JGu=qAkJE3H8iJ_0A0fQTCXrBJkWJDBRA@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
	<CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
	<CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com>
	<CAH3drwacayQEZHOidbKKuJ3KjgMvnYzT0S0csXV2QwSmC8nMxg@mail.gmail.com>
	<CAL1RGDXotXpZXUeR6JGu=qAkJE3H8iJ_0A0fQTCXrBJkWJDBRA@mail.gmail.com>
Date: Thu, 7 Jun 2012 12:22:00 -0400
Message-ID: <CAH3drwYGH23iuLFnrjnCx3wWsBH9s_QzQ4uOtOBOFKW-D1d3Xg@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
From: Jerome Glisse <j.glisse@gmail.com>
To: Roland Dreier <roland@purestorage.com>
Cc: Brian Gitonga Marete <marete@toshnix.com>,
        LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 11:35 AM, Roland Dreier <roland@purestorage.com> wrote:
>> Update your libdrm to libdrm from git should fix your issue.
>
> That's unfortunate -- it means a kernel change breaks working userspace?

Yes and no, welcome to GPU world. So this patch is suppose to report
some GPU informations to userspace, sadly on some GPU we report wrong
informations (that's a bug). So solution is to fix kernel to report
right information, i think the following patch does that.
http://www.mail-archive.com/stable@vger.kernel.org/msg09247.html

The no side, is to have it broken you also need to have upgraded your
libdrm, ie old libdrm/radeon with this kernel will work as previously.
This issue have been fix recently in libdrm :
http://cgit.freedesktop.org/mesa/drm/commit/?id=c2b77a02d4e188cfa6d1b73a721946fd9b1d3577

Of course here i am assuming that the bug Brian is experiencing is
related to wrong tile infos reporting.

Cheers,
Jerome
