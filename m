Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2DRUIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:08:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2DRUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:08:04 -0400
Date: Wed, 18 Apr 2012 21:10:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: PINTU KUMAR <pintu_agarwal@yahoo.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
Message-ID: <20120418211032.47b243da@pyramind.ukuu.org.uk>
In-Reply-To: <CAFLxGvz5tmEi-39CZbJN+0zNd3ZpHXzZcNSFUpUWS_aMDJ4t6Q@mail.gmail.com>
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
	<CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com>
	<1334490429.67558.YahooMailNeo@web162006.mail.bf1.yahoo.com>
	<CAFLxGvz5tmEi-39CZbJN+0zNd3ZpHXzZcNSFUpUWS_aMDJ4t6Q@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2012 14:10:00 +0200
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> On Sun, Apr 15, 2012 at 1:47 PM, PINTU KUMAR <pintu_agarwal@yahoo.com> wrote:
> > Moreover, this is mainly meant for mobile phones where there is only *one* user.
> 
> I see. Jet another awful hack.
> Mobile phones are nothing special. They are computers

Correct - so if it is showing up useful situations then they are also
useful beyond mobile phone.

> Every program which is allowed to use this interface will (ab)use it.

If you expose it to userspace then you would want it very tightly
controlled and very much special case. Within the kernel using it
internally within things like CMA allocators seems to make more sense.

I think you overestimate the abuse. It's an interface which pushes clean
pages that can be cheaply recovered out of memory. It doesn't guarantee
the caller reaps the benefit of that, and the vm will continue to try and
share out any new resource fairly.

Alan
