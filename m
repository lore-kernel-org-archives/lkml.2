Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1KVAzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:55:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36024 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1KVAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:55:34 -0500
MIME-Version: 1.0
In-Reply-To: <4ECAF15E.1070008@caviumnetworks.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
 <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com>
 <4ECACF68.3020701@gmail.com> <CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
 <4ECAE314.9060209@gmail.com> <CA+55aFx==PGGLX9YXv1GOeTja4W0PSW8U4i8zkmtiZwqmFwHFw@mail.gmail.com>
 <4ECAF15E.1070008@caviumnetworks.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 16:55:13 -0800
X-Google-Sender-Auth: r5e_ivVufvRtZuHx83ZZAzJUmAk
Message-ID: <CA+55aFyiV-W_7zOuu26jsUsCDTxHh41z8sEgL0D94xFooAJxFA@mail.gmail.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and HPAGE_SIZE
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Robin Holt <holt@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 4:48 PM, David Daney <ddaney@caviumnetworks.com> wrote:
>
> Really Linus, did you read the other half of the message you quoted?

Sorry no. It was just an automatic reaction along the lines of "oh
christ, is this argument still going on"?

I'm ok with magic gcc function attributes, although I still don't see
why you need that symbol so badly.

Quite frankly, some MIPS-only patch is *not* important-enough to worry
about this. I'd rather have the simpler "that symbol doesn't exist,
and MIPS just needs an #ifdef".

I realize that we *used* to have code that did that

   if (something_that_evaluates_to_zero) {
       .. use HPAGE_MASK ..

but considering that we don't have that any more and people are happy,
I'm not all that convinced that we need to try to re-introduce it.

                     Linus
