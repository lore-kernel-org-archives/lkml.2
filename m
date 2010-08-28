Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab0H1PN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:13:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46453 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0H1PN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=syoJvJcPV+dcklPVlyfu1cXEP38keyuOv9VVVgEeMNREUXer1Ni/oL5cgDQOHh2NVH
         z++1pwWeJ0W+f3zi4Egd8ETJ8DOb+uxhNhnzdAEnWt4EyJhITqmN6/6kmZG5NHw+Tzyt
         0ktVvaeOMnJwtwBYWXS4w4nZQUvH/0Wfo9xSs=
MIME-Version: 1.0
In-Reply-To: <20100828142455.742059699@chello.nl>
References: <20100828141637.421594670@chello.nl>
	<20100828142455.742059699@chello.nl>
Date: Sat, 28 Aug 2010 18:13:13 +0300
X-Google-Sender-Auth: tKPPY3U4vIl11Saak28hnYl8w3o
Message-ID: <AANLkTi=-TsSNrv8woU7Ko7QmSPWhBnQAypBvt01Z+9i5@mail.gmail.com>
Subject: Re: [PATCH 05/20] mm: Simplify anon_vma refcounts
From: Pekka Enberg <penberg@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 5:16 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> This patch changes the anon_vma refcount to be 0 when the object is
> free. It does this by adding 1 ref to being in use in the anon_vma
> structure (iow. the anon_vma->head list is not empty).
>
> This allows a simpler release scheme without having to check both the
> refcount and the list as well as avoids taking a ref for each entry
> on the list.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

FWIW,

Acked-by: Pekka Enberg <penberg@kernel.org>
