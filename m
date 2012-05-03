Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2ECIHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:07:51 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48526 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752482Ab2ECIHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <4FA23A83.4040604@kernel.org>
References: <4F9E39F1.5030600@kernel.org>
	<CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com>
	<4F9E44AD.8020701@kernel.org>
	<CAOJsxLGd_-ZSxpY2sL8XqyiYxpnmYDJJ+Hfx-zi1Ty=-1igcLA@mail.gmail.com>
	<4F9E4F0A.8030900@kernel.org>
	<alpine.LFD.2.02.1205031019410.3686@tux.localdomain>
	<4FA23A83.4040604@kernel.org>
Date: Thu, 3 May 2012 11:07:47 +0300
X-Google-Sender-Auth: G1vdFInBlZKSCDIiCcksveYL6xc
Message-ID: <CAOJsxLHxLbzp+nfc72pzzyAe8W5w-phbHhREdJ7Mg5P9JHeF5A@mail.gmail.com>
Subject: Re: vmevent: question?
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 10:57 AM, Minchan Kim <minchan@kernel.org> wrote:
> Sorry for my poor explanation.
> My point is when userspace get vmevent_event by reading fd, it could enumerate
> several attribute all at once.
> Then, one of attribute(call A) made by vmevent_match in kernel and other attributes(call B, C, D)
> are just extra for convenience. Because there is time gap when kernel get attribute values, B,C,D could be stale.
> Then, how can user determine which event is really triggered? A or B or C or D?
> Which event really happens?

Right. Mark the matching values with something like
VMEVENT_ATTR_STATE_CAPTURED should be sufficient?
