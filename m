Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0JKOiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:38:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45691 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0JKOiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XN5Oq/1k81wED2pvs//0laqzS/xVj29S7zCgYvvtm5cCju//G4mW04wVIEtYFoPpta
         6cwgIoshWY76GBWk0XaGQgGVPz75LXlvWubIJii+h4hS/b3nCno+Bwap4phVfCGYG2Hi
         rcFZOoBeTXtWGuoEWMxBFGv2MXG003NNkzURI=
MIME-Version: 1.0
In-Reply-To: <1286781641.2336.63.camel@twins>
References: <1286612169-27529-1-git-send-email-linus.walleij@stericsson.com>
	<1286639626.1891.0.camel@laptop>
	<AANLkTi=JfJknPNMiMXnK=kZj+ECJTE423AfjuiE67afu@mail.gmail.com>
	<1286781641.2336.63.camel@twins>
Date: Mon, 11 Oct 2010 16:38:14 +0200
Message-ID: <AANLkTinSW-6OXkUeiaB7SZObXWBseJ9+HRRAqVnbrQFL@mail.gmail.com>
Subject: Re: [PATCH] sched: SCHED_RESET_ON_FORK to recalculate load weights
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/11 Peter Zijlstra <peterz@infradead.org>:

> OK, so the problem is that if a RR/FIFO task does s fork() and it has
> SCHED_RESET_ON_FORK set, the child normalization fails to properly set
> the weight?
>
> Does (as Mike just suggested) removing that whole RT clause in
> set_load_weight() work for you?

Yep it sure does! Time to drop some weight.
Sent a new patch for this...

Yours,
Linus Walleij
