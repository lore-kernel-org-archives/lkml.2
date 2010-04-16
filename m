Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab0DPWS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 18:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635Ab0DPWSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 18:18:55 -0400
Message-ID: <4BC8E252.8030400@suse.com>
Date: Fri, 16 Apr 2010 18:18:58 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.5 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH RFC]  buffer_head: remove redundant test from wait_on_buffer
References: <1271415499.2075.19.camel@localhost> <20100416145123.283f216c.akpm@linux-foundation.org>
In-Reply-To: <20100416145123.283f216c.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/16/2010 05:51 PM, Andrew Morton wrote:
> And while we're there...
> 
> This might make reiserfs explode.
> We can remove __wait_on_buffer() altogether now.  For some strange reason
> reiserfs calls __wait_on_buffer() directly.  Maybe it's passing in
> zero-ref buffers.  If so, we'll get warnings now and shall need to look at
> that.

I don't think that's the case. I think reiserfs just calls
__wait_on_buffer just to skip the duplicate buffer_locked() test since
every call is in an "if buffer_locked()" block. I don't think it's
passing in zero-ref buffers anywhere, and I'd prefer it to explode if it is.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkvI4lIACgkQLPWxlyuTD7Ju9wCgphZEI8r9jB+75PIxE4l/S/H+
jlEAnR+vo57PB2ZH+PhTSoxWnQ9V74M3
=bQAA
-----END PGP SIGNATURE-----
