Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0HTN1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:27:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0HTN1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:27:49 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: struct fanotify_event_metadata
References: <m21va1ozqx.fsf@igel.home>
	<201008191644.29299.tvrtko.ursulin@sophos.com>
	<1282240426.21419.1716.camel@acb20005.ipt.aol.com>
	<201008201002.16235.tvrtko.ursulin@sophos.com>
	<m3pqxd7ift.fsf@hase.home>
	<1282310016.21419.2161.camel@acb20005.ipt.aol.com>
X-Yow: I love FRUIT PICKERS!!
Date: Fri, 20 Aug 2010 15:27:42 +0200
In-Reply-To: <1282310016.21419.2161.camel@acb20005.ipt.aol.com> (Eric Paris's
	message of "Fri, 20 Aug 2010 09:13:36 -0400")
Message-ID: <m339u976sx.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> Can you help me understand the packed attribute and why it hurts in this
> case?

It changes the alignment of all applicable objects to 1 which means that
the compiler cannot assume _any_ aligment.  Thus on STRICT_ALIGNMENT
targets it has to use more expensive access methods to avoid generating
unaligned loads and stores (unless it can infer proper alignment from
the context).

You can add an aligned attribute to raise the assumed alignment again.
Of course, this can only work correctly if the actual alignment of the
object matches the declared one.

> I'm going to compile a couple of test programs (I only have x86 and
> x86_64) to see if I can find what the assembly is doing different but
> maybe you can point me at the information more easily?

Neither x86 nor x86-64 are STRICT_ALIGNMENT targets.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
