Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2BUEWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:22:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40223 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2BUEWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:22:33 -0500
Message-ID: <4F431BE8.1030201@zytor.com>
Date: Mon, 20 Feb 2012 20:22:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, thomas@m3y3r.de, raven@themaw.net,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 3.3-rc4
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com> <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com> <20120219.144947.660678318380307878.davem@davemloft.net> <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
In-Reply-To: <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 12:02 PM, Linus Torvalds wrote:
> On Sun, Feb 19, 2012 at 11:49 AM, David Miller <davem@davemloft.net> wrote:
>>
>> A real shame, this should have used "__aligned_u64" from the
>> beginning.
> 
> I agree. Sadly, this is exactly the kind of thing that is *really*
> easy to overlook, and once it is overlooked we're screwed because
> fixing it just breaks the native 32-bit case.
> 

I'm starting to think we should compile the kernel with -Wpadded by
default (currently it's only done at "warning level 3", which I doubt
anyone ever uses, especially since that also includes -Wpacked which is
an actively toxic warning) and force people to add explicit padding
where it needs to go, if necessary.  Unfortunately even that doesn't
guarantee compatibility with userspace, but it's at least something.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

