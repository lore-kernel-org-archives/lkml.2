Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab2D3UDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:03:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60347 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454Ab2D3UDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:03:53 -0400
Message-ID: <4F9EEFF5.4000703@zytor.com>
Date: Mon, 30 Apr 2012 13:03:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized
 pipe
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com> <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com> <4F9DDD3E.6010801@zytor.com>
In-Reply-To: <4F9DDD3E.6010801@zytor.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 05:30 PM, H. Peter Anvin wrote:
> Incidentally, I think there is a good reason to add a v6 packet type
> regardless, for efficiency: with packetized pipes there really is no
> point in sending a packet which is mostly padding for no good reason.

Thinking about it some more: for v6, I wouldn't use a packetized pipe at
all (due to the unnecessary extra buffer consumption.)  Instead just put
the message size in the header and read a large chunk, which may end up
being more than one packet and may end up with a partial packet at the
end.  *This is okay*, because there is only one reader, and any
additional data needed will be gotten the next time around the loop.

	-hpa

