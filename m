Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0IFFdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:33:22 -0400
Received: from mailhost-x2-m4.netultra.net ([78.40.49.234]:62281 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754Ab0IFFdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:33:19 -0400
Date: Mon, 6 Sep 2010 07:32:55 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.*: horrible (exponential? >linear) slowdown to
 unusability (ACPI idle?)
Message-ID: <20100906053255.GA23340@brouette>
References: <87zkvx2ese.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zkvx2ese.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Nix <nix@esperi.org.uk> [2010-09-05 01:51]:
> This is a preliminary report: I haven't bisected this problem yet, or
> isolated it in any significant fashion.

> What I can say is this.

> In 2.6.35.3, but not in 2.6.34.1, some of my systems experience an
> increasingly severe series of stalls whenever the system is idle. The
> stalls get worse at a rate above linear: about fifty seconds after they
> start, I am waiting five to ten seconds for responses to keystrokes. It
> is very hard to get anything much done in this situation: even
> restarting is hard. 'perf top' shows nothing using the time, but the
> load average is pegged at 1.

> I can verify that this does not happen on my embedded Geode box, a
> 32-bit system without ACPI support. It does happen on my x86-64 systems,
> all of which are running 64-bit kernels with ACPI. These systems are all
> running with CONFIG_NOHZ, so I tried turning it off. The problem got
> enormously worse: the kernel lasted 6.4 seconds after initial boot and
> about two seconds after entering userspace before stalling completely.

I think this is related to what has been discussed in this thread:
http://lkml.org/lkml/2010/7/14/11

I've not seen the problem with 2.6.35.4 yet, and only once with
2.6.35.3. Zeno said it disappeared for him when he started to use
2.6.35-stable.

So if you can reproduce it quite easily, I guess bisection (even
painful) will be the best way to get (hopefuly) an idea of where the
problem might come from...

-- 
Damien Wyart
