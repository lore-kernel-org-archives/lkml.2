Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0HTOPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:15:24 -0400
Received: from thunk.org ([69.25.196.29]:41103 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab0HTOPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:15:22 -0400
Date: Fri, 20 Aug 2010 09:56:12 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Message-ID: <20100820135612.GC4053@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 10:45:43AM +0200, Miloslav Trmač wrote:
> Hello, following is a patchset providing an user-space interface to
> the kernel crypto API.  It is based on the older, BSD-compatible,
> implementation, but the user-space interface is different.

What's the goal of exporting the kernel crypto routines to userspace,
as opposed to just simply doing the crypto in userspace?  Is it to
access hardware crypto accelerators?  (1) I wasn't aware the kernel
crypto routines actually used crypto accelerators, and (2) more often
than not, by the time you take into account the time to move the
crypto context as well as the data into kernel space and back out, and
after you take into account price/performance, most hardware crypto
accellerators have marginal performance benefits; in fact, more often
than not, it's a lose.

If the goal is access to hardware-escrowed keys, don't we have the TPM
interface for that already?

So I'm bit at a list what's the whole point of this patch series.
Could you explain that in the documentation, please?  Especially for
crypto, explaining when something should be used, what the threat
model is, etc., is often very important.

Thanks, regards,

						- Ted


