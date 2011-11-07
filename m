Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1KGN55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:57:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51655 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab1KGN54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:57:56 -0500
Date: Mon, 7 Nov 2011 13:58:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111107135823.3a7cdc53@lxorguk.ukuu.org.uk>
In-Reply-To: <1320675607.2330.0.camel@offworld>
References: <1320614101.3226.5.camel@offbook>
	<20111107112952.GB25130@tango.0pointer.de>
	<1320675607.2330.0.camel@offworld>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, rlimit approach guarantees a simple way of dealing with users
> across all tmpfs instances.

Which is almost certainly not what you want to happen. Think about direct
rendering.

For simple stuff tmpfs already supports size/nr_blocks/nr_inodes mount
options so you can mount private resource constrained tmpfs objects
already without kernel changes. No rlimit hacks needed - and rlimit is
the wrong API anyway.

Alan

