Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab0FGIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:16:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0FGIQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:16:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=X7/ZPIiGv+efWrF2zGsOxtr3iU+CrWTfOyIi4Dl+KDmFnr+5aDO4niuWAl/L4DypF
	hq2JcJpS0BvJtAKGzrYlw==
MIME-Version: 1.0
In-Reply-To: <20100607080357.GB15851@infradead.org>
References: <1275834706.7227.545.camel@mulgrave.site>
	<alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
	<1275844114.7227.552.camel@mulgrave.site>
	<20100606190525.GA20517@infradead.org>
	<AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
	<20100606192405.GA7559@infradead.org>
	<AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
	<20100607080357.GB15851@infradead.org>
Date: Mon, 7 Jun 2010 01:16:23 -0700
Message-ID: <AANLkTiky_4yCx5RQkK5eums7vcQPy2uSMyd41hQ2MA-6@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Brian Swetland <swetland@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, "Arve Hj?nnev?g" <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 1:03 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Jun 06, 2010 at 12:58:10PM -0700, Brian Swetland wrote:
>> The group ID stuff works incredibly well for gating device access --
>> we ensure that devices that need access from various processes end up
>> with perms like 0660 root audio (say for a raw audio interface), and
>> then we assure that processes which have the "may use audio hardware"
>> permission are executed with audio as an additional group.  We ended
>> up using the same model to control socket, raw socket, and bt socket
>> access because at the time we could not find a reasonable way to grant
>> or exclude such permissions on a process by process basis.
>> Maintaining about 20-30 lines of diffs to make that work was not a bad
>> tradeoff (and we don't expect those patches to go upstream).  If
>> there's a way to accomplish this without patching the kernel, we're
>> all ears.
>
> I'd have to take a look again on how this is implemented in details.
> If it's just overriding the capabilities it's really hard to do in
> the current model as the capabilities aren't fine grained enough
> currently, even with the existing per-file and per-process capabilities.
> If it's mostly overriding regular unix file permissions it's easily
> doable with ACLs, or in fact just with group ownership at the filesystem
> level, without kernel hacks.

For device nodes, we just use group ownership and it works fine with
no kernel modifications.  For the "can create socket", "can create bt
socket", and "can create raw socket" permissions we ended up throwing
together a patch tying those operations to being in the appropriate
group.  Obviously a hack, but it was the most straightforward solution
we could find at the time.

Brian
