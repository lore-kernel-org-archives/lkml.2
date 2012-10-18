Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab2JRVbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:31:15 -0400
Received: from science.horizon.com ([71.41.210.146]:26498 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756350Ab2JRVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:31:14 -0400
Date: 18 Oct 2012 17:31:12 -0400
Message-ID: <20121018213112.3903.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: sign the modules at install time
Cc: jwboyer@redhat.com, linux@horizon.com, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The micturator of the Holy Penguin Pee spake:
> (Side note: I hope people realize that the random key is generated
> with a 100-year lifespan. So if you build a kernel today, you do
> potentially have a "year-2112 problem". I'm not horribly worried, but
> I *am* a bit worried about 32-bit time_t overflow and I hope 32-bit
> openssl doesn't do anything odd)

Well, the kernel uses time_t, which should be >= 64 bits on any machine
still operational outside the computer history museum at that time.

But it also allows an expiry time of 0 to indicate "no expiration".  


It's worth noting that in X.509 *keys* don't have expirations; only
*certifications* do.  That is, the signature binding a name to the key.
You can issue any number of certificates, with different expiration dates,
on the same key.

(The only reason that there's this "certificate = key" confusion
is that X.509 doesn't specify a format for a bare key, so the
certificate format is also used as a key container.)

I haven't figured out the kernel key loading procedure, but it's not
clear that it even sets the expiry time.  It does not, for example,
have any equivalent to the X.509 validity start time, so it wasn't
designed with importing certificates in mind.


Even if it is set, you could disable expiration checking on key lookup
and not care about expiration dates.  (Pass no_state_check=true as the
last argument to keyring_search_aux.)
