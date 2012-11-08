Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2KHV76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:59:58 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:60058 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103Ab2KHV74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:59:56 -0500
Date: Thu, 8 Nov 2012 07:20:01 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, Matt Mackall <mpm@selenic.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] random: prime last_data value per fips requirements
Message-ID: <20121108122001.GC5859@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Neil Horman <nhorman@tuxdriver.com>, Matt Mackall <mpm@selenic.com>,
	linux-crypto@vger.kernel.org
References: <1352216153-25359-1-git-send-email-jarod@redhat.com>
 <1352216562-25659-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352216562-25659-1-git-send-email-jarod@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 10:42:42AM -0500, Jarod Wilson wrote:
> The value stored in last_data must be primed for FIPS 140-2 purposes. Upon
> first use, either on system startup or after an RNDCLEARPOOL ioctl, we
> need to take an initial random sample, store it internally in last_data,
> then pass along the value after that to the requester, so that consistency
> checks aren't being run against stale and possibly known data.
> 
> v2: streamline code flow a bit, eliminating extra loop and spinlock in the
> case where we need to prime, and account for the extra primer bits.
> 
> v3: extract_buf() can't be called with spinlock already held, so bring
> back some extra lock/unlock calls.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Matt Mackall <mpm@selenic.com>
> CC: linux-crypto@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Thanks, applied to the /dev/random git tree.

						- Ted
