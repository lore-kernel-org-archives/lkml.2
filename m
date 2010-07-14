Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab0GNThB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:37:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34103 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0GNTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=xnZP1v3iGsC7zJsMD/goih/Hnw3vtjqVvsnaukLsw+3nLwkCmWAvd/Cuaa9EqrRhYh
         R9fTtKBzlCGr14faNsISKwa2b2CrENfRj5rrSUA45rUQCeYZmlcOJInMIO5kai3ZHbL3
         aPMA5VzrbtURFGbbYPXuuHMJ3BiuNhjjlu5lc=
Date: Wed, 14 Jul 2010 21:36:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100714193652.GA13630@nowhere>
References: <20100714154923.947138065@efficios.com> <20100714155804.049012415@efficios.com> <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 12:14:01PM -0700, Linus Torvalds wrote:
> On Wed, Jul 14, 2010 at 11:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >>  NMI entry:
> >
> > I think at this point [NMI re-entry] we've corrupted the top of the NMI kernel
> > stack already, due to entering via the IST stack mechanism, which is
> > non-nesting and which enters at the same point - right?
> 
> Yeah, you're right, but we could easily fix that up. We know we don't
> need any stack for the nested case, so all we would need to do is to
> just subtract a small bit off %rsp, and copy the three words or so to
> create a "new" stack for the non-nested case.
> 
> > We could solve that by copying that small stack frame off before entering the
> > 'generic' NMI routine - but it all feels a bit pulled in by the hair.
> 
> Why? It's much cleaner than making the _real_ codepaths much worse.



There is also the fact we need to handle the lost NMI, by defering its
treatment or so. That adds even more complexity.

