Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2HUGio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:38:44 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:51372 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab2HUGim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:38:42 -0400
Message-ID: <50332CEF.7010204@msgid.tls.msk.ru>
Date: Tue, 21 Aug 2012 10:38:39 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: root=PARTUUID for MBR/NT disk signatures?
References: <502EC16C.4030007@wwwdotorg.org> <20120820182254.GQ24861@google.com> <50328258.9030800@wwwdotorg.org> <CABqD9hY-Z9uBcYyeCa=8f8eeXkGNjPKxbwpMPi3vs3776vF6iQ@mail.gmail.com>
In-Reply-To: <CABqD9hY-Z9uBcYyeCa=8f8eeXkGNjPKxbwpMPi3vs3776vF6iQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.08.2012 08:47, Will Drewry wrote:
[]
> Functionally, I suspect this will work fine, but I am concerned that
> it is a bad move from an efficiency perspective (not unfixable
> though).  Right now, the user-supplied value is converted from
> string-uuid to packed-uuid.  This is then memcmp'd across any and all
> partitions - be it 2 or 200 - across all attached storage.  If we move
> to a pure string, then we end up needing to unpack every packed UUID
> at disk scan time (or search, depending on impl) rather than just the
> one user supplied value.
> 
> Perhaps the cost is negligible on modern machines, but it seems like
> the wrong place to put the cost (per entry rather than per search
> value).

Amount of work needed to READ all the partition tables might be
quite a bit larger than strcmp'ing it all.  I think.

/mjt
