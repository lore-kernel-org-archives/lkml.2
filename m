Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2BQBjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:39:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53129 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2BQBjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:39:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120216231533.GA7392@redhat.com>
References: <20120216231533.GA7392@redhat.com>
Date: Thu, 16 Feb 2012 17:39:38 -0800
X-Google-Sender-Auth: 3ptaknIgeL-45Fw1wZ27Fftqe98
Message-ID: <CANcMJZAfT7Sz=5D=PVQwoy_hvEYZxowUxBo4EXN-U72mecE9SQ@mail.gmail.com>
Subject: Re: soft lockup detector & virtualisation
From: john stultz <johnstul@us.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Eric B Munson <emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 3:15 PM, Dave Jones <davej@redhat.com> wrote:
> Lately I've noticed quite a few soft lockup bugs being reported.
> In many of them, they're coming from inside virtual guests.
>
> Is the softlockup detector fundamentally broken in this situation ?
>
> If the host doesn't schedule the guest for whatever reason,
> or the user suspends the VM and resumes it later ?
>
> Here's the most recent example:
> https://bugzilla.redhat.com/attachment.cgi?id=563767
>
> In many of these, the code where it's "stuck" isn't anything
> special, which is why I think the guest just hasn't had a
> timeslice in 185 seconds.
>
> Is there some way we can perhaps detect we're running virtualised,
> and disable the detector automatically ?

I think Eric's work (See "Add check for suspended vm in softlockup
detector" sent out today) tries to address this issue.

thanks
-john
