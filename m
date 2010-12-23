Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0LWJ6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:58:38 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52949 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0LWJ6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:58:30 -0500
Subject: Re: + kmap-types-clean-up-and-optimization.patch added to -mm tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, JBeulich@novell.com, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201012222248.oBMMmbcF023808@imap1.linux-foundation.org>
References: <201012222248.oBMMmbcF023808@imap1.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 10:58:30 +0100
Message-ID: <1293098310.2170.415.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 14:48 -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      kmap-types: clean up and optimization
> has been added to the -mm tree.  Its filename is
>      kmap-types-clean-up-and-optimization.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 

> ------------------------------------------------------
> Subject: kmap-types: clean up and optimization
> From: "Jan Beulich" <JBeulich@novell.com>
> 
> Several of the types aren't being used at all anymore - those can be
> deleted altogether.  

NO! That's wrong, in fact non of them are being used, but removing them
will decrease the number of kmap_atomic slots, but those are still being
used.

> Others are used only by single components that can be
> assumed to be enabled everywhere, so those are made dependent upon
> CONFIG_* settings.  Since this somewhat conflicts with the sequential gap
> markers used under __WITH_KM_FENCE, and since this can be simplified
> anyway, fold the enumerator definitions with the (modified accordingly)
> KMAP_D() macro always.
> 
> The whole point of the reduction is that, at least on ix86, the number of
> kmap types can (depending on configuration) affect the amount of low
> memory, and thus unused types should be avoided if possible.

Feh, its only a few pages and since there is no way to actually tell if
you've got enough kmap atomic pages other than experiencing runtime
errors, removing them must be done with utmost prudence.

> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Nacked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
