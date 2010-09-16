Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0IPV4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:56:53 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47439 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab0IPV4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cVkbS8dB9JTeLLE1iBW6gKd7Bru0d3KYHLxC4PC07Wmd/sd18IXGNmYalZYge++CEf
         ErcqZCIIExiyHhBUBLRuky5BIVYk6+tXAwEZzgzVwFZGmikP1Is2nJ1mbwDxFtSqkIAI
         /q1SpeWpznXvDgoBrlN14iPSt3XI25POPB8F8=
MIME-Version: 1.0
In-Reply-To: <20100915222216.GF27658@esdhcp04044.research.nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com>
	<20100915124831.GB27658@esdhcp04044.research.nokia.com>
	<AANLkTi=hPcXC1=Lrey1H_UHRJRJ-NdTsvmyxgP_n+dM8@mail.gmail.com>
	<20100915222216.GF27658@esdhcp04044.research.nokia.com>
Date: Thu, 16 Sep 2010 14:56:50 -0700
X-Google-Sender-Auth: iWokjTeD-VFZG3sCHeDJHJxJR7Q
Message-ID: <AANLkTikgi38O3=MsVNc-X64PnLOFNktC_x9Y3vQ7CbD+@mail.gmail.com>
Subject: Re: [PATCH 0/2] ia64: possible module unwind table optimisation
From: Tony Luck <tony.luck@intel.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 3:22 PM, Phil Carmody
<ext-phil.2.carmody@nokia.com> wrote:
> Turn on kmemleak, or anything else which repeatedly runs up the stack just
> for the fun of gathering backtraces. Kmemleak's what caused us to notice
> the issue in our ARM-based environment.

kmemleak needs CONFIG_STACKTRACE - which I haven't got around to putting
into ia64 yet.  I dug up an earlier attempt at doing so, and turned on kmemleak,
but it crashes early in boot (before ever getting to my stack tracer)
in possibly
the first call to kmem_cache_alloc().  With SLUB the error is an unaligned
reference to 0xffffffffffffffff, with SLAB I get a NULL deref.

:-(

-Tony
