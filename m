Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab1AKX3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:29:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755584Ab1AKX3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:29:43 -0500
MIME-Version: 1.0
In-Reply-To: <4D2CE5C8.60601@de.ibm.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 15:28:51 -0800
Message-ID: <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 3:20 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> Now nouveau framebuffer is completely broken on my T61p (01:00.0 VGA compatible controller: nVidia Corporation G84M [Quadro FX 570M] (rev a1))
> During startup the framebuffer shows only stripes and a blank
> screen after suspend/resume.
> I also see lots of TRAP messages. (see below).
> X11 seems to work fine though...

Can you try to bisect?

It's a *bit* easier to do if you start out at the drm merge, and only
bisect that part, ie

  MERGE=5b2eef966cb2ae307aa4ef1767f7307774bc96ca
  git bisect start
  git bisect bad $MERGE^2
  git bisect good $MERGE^1

(the above assumes that the merge itself isn't what caused the
problems) and that way you should only need to bisect through the
actual new DRM commits.

                   Linus
