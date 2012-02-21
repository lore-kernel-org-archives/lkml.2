Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab2BUF1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:27:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40505 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2BUF1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:27:40 -0500
Message-ID: <4F432B27.4000708@zytor.com>
Date: Mon, 20 Feb 2012 21:27:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian Kent <raven@themaw.net>, David Miller <davem@davemloft.net>,
        thomas@m3y3r.de, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.3-rc4
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com> <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com> <20120219.144947.660678318380307878.davem@davemloft.net> <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com> <1329794974.2226.11.camel@perseus.themaw.net> <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com> <1329796956.2226.20.camel@perseus.themaw.net> <CA+55aFzVyr_U0-2Df2bqcX7G6DvkEGp=1N+ck4=EHuq=NY0Wkw@mail.gmail.com> <1329799959.2226.32.camel@perseus.themaw.net> <CA+55aFwBD7pbOcSUVguF+vFAs85JhNpjJgZtDKjEJA0PVXrhkw@mail.gmail.com> <CA+55aFzcWjPrK4csbThuGimt6bHC+bcgFhj-r8d3M1MxhN_HKg@mail.gmail.com>
In-Reply-To: <CA+55aFzcWjPrK4csbThuGimt6bHC+bcgFhj-r8d3M1MxhN_HKg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 09:21 PM, Linus Torvalds wrote:
> On Mon, Feb 20, 2012 at 9:06 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So it really is limited to only x86.
> 
> Oh, and if people really are using "uname()" to figure out that they
> are running a 64-bit kernel, then we should probably make uname() use
> "is_compat_task()" instead of checking the PER_LINUX32 personality.
> 
> So we already do have support for returning a different machine-name
> to 32-bit binaries, but it uses the "personality" thing that nobody
> cares about, rather than the compat layer. Looks like purely
> historical reasons.
> 

No, it serves a real function.  I use both directions of this to deal
with various compatibility things.  PER_LINUX32 lets you run, say, an
installer as if it was on a 32-bit program, even if it is written in a
scripting language (and hence running a native 64-bit interpreter).
Similarly, a 32-bit legacy binary can still function as part of a bigger
64-bit system.

So let's not change that just because someone did something idiotic.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

