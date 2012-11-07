Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2KGQoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab2KGQop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:44:45 -0500
Date: Wed, 7 Nov 2012 11:43:58 -0500
From: Dave Jones <davej@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Eric Dumazet <edumazet@chromium.org>
Subject: Re: [PATCH] tcp: Replace infinite loop on recvmsg bug with proper
 crashusers
Message-ID: <20121107164358.GA20495@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	James Morris <jmorris@namei.org>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sameer Nanda <snanda@chromium.org>,
	Mandeep Singh Baines <msb@chromium.org>,
	Eric Dumazet <edumazet@chromium.org>
References: <1352247335-10396-1-git-send-email-jwerner@chromium.org>
 <20121107013907.GA31185@redhat.com>
 <CAODwPW-636Sn3B4CYajvrgccXxresZwPLg2UFz6xDDk9-FfTYQ@mail.gmail.com>
 <20121107155434.GA17677@redhat.com>
 <1352305752.3140.4449.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352305752.3140.4449.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 08:29:12AM -0800, Eric Dumazet wrote:
 > On Wed, 2012-11-07 at 10:54 -0500, Dave Jones wrote:
 > 
 > > It sounds more appropriate to me, instead of silently wedging the box.
 > > At least with that approach we have a chance of finding out what happened.
 > 
 > Its quite the opposite.
 > 
 > If bug is still there 6 months after the commits that broke the drivers,
 > (making an old bug visible) that means that people never realized the
 > bug was there.

dude, look at the bug reports I just pointed you at.
People _are_ aware there are bugs there.

If you turn that into a BUG() those reports would never have been filed.
How is that increasing awareness ?  People are going to see wedged computers,
and hit the reset button. If we're lucky, we'll get photos of someone lucky
enough to have hit it while at the console, not in X. But this is a huge
step backwards for debugability.

 > I understand a distro maintainer has its own choices, but for upstream
 > kernel we want to have early reports.

I'm running out of ways to word this, but I'll try again.
You won't get those early reports if you turn this into a BUG().

 > This bug is fatal and a security issue. BUG() is appropriate.

turning a bug into a remote DoS is also a security issue.

	Dave

