Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2KGQ3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:29:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2KGQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:29:16 -0500
Subject: Re: [PATCH] tcp: Replace infinite loop on recvmsg bug with proper
 crashusers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Eric Dumazet <edumazet@chromium.org>
In-Reply-To: <20121107155434.GA17677@redhat.com>
References: <1352247335-10396-1-git-send-email-jwerner@chromium.org>
	 <20121107013907.GA31185@redhat.com>
	 <CAODwPW-636Sn3B4CYajvrgccXxresZwPLg2UFz6xDDk9-FfTYQ@mail.gmail.com>
	 <20121107155434.GA17677@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 08:29:12 -0800
Message-ID: <1352305752.3140.4449.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 10:54 -0500, Dave Jones wrote:

> It sounds more appropriate to me, instead of silently wedging the box.
> At least with that approach we have a chance of finding out what happened.

Its quite the opposite.

If bug is still there 6 months after the commits that broke the drivers,
(making an old bug visible) that means that people never realized the
bug was there.

I understand a distro maintainer has its own choices, but for upstream
kernel we want to have early reports.

This bug is fatal and a security issue. BUG() is appropriate.

If the driver cant be fixed, it should be marked broken.

So I personally NACKed patch to hide the bug, trying to be friendly to
the user.


