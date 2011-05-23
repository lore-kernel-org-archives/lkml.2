Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab1EWTDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:03:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54547 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab1EWTDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=EebtKHn3PyY5GZgOwCOHxN3OrILI8ujzFmCFgQmHBqC0ZjJpd0RkvAwhNdlhL+nKgA
         54cTgjgU+3nXXqeCBwycBOa+3DUF3G1hnlbaZPgnEJ2ppIq4nd/A7hFPdtsuW0goNyM9
         /ohuCIJfryT8fz2V6A0bfQdXtQlfQ21THAchM=
MIME-Version: 1.0
In-Reply-To: <20110523104902.GB24674@elte.hu>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu> <1306089922.1806.27.camel@dan>
 <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com> <1306110336.25049.7.camel@dan>
 <20110523104902.GB24674@elte.hu>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 23 May 2011 12:02:41 -0700
X-Google-Sender-Auth: PXkxR30tZmYCvEkhG8O9z0Y9kGk
Message-ID: <BANLkTimOycEf5ZyH64Bee-b1ZkbBKXNGzg@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 3:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Well, since entropy does not get reduced on addition of independent variables
> the right sequence is (pseudocode):
>
>        rnd  = entropy_cycles();
>        rnd += entropy_rdrand();
>        rnd += entropy_RTC();
>        rnd += entropy_system();

I think you mean concatenation rather than addition? Or perhaps XOR,
or a hash? It's pretty easy to show that the addition of n random
variables evenly distributed between [0, 1] converges to 1/2 n  +-
1/sqrt(n) (or numbers to that effect), which gives an attacker better
chances than they would otherwise if they target the center of the
distribution.

But none of this is to detract from your main point, which still
holds. Structuring it such that other sources of randomness can be
included as available keeps options open.

~r.
