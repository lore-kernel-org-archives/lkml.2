Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247Ab0HFBRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:17:33 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59938 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0HFBRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:17:30 -0400
Date: Fri, 6 Aug 2010 09:17:06 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and
	cryptomgr problem
Message-ID: <20100806011706.GA21657@gondor.apana.org.au>
References: <23662.1281056463@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23662.1281056463@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 02:01:03AM +0100, David Howells wrote:
> 
> but it's not being found by the crypto routines.  By GIT bisection, I note
> that this problem is introduced in the following commit:
> 
> 	commit 0b767f96164b2b27488e3daa722ff16e89d49314
> 	Author: Alexander Shishkin <virtuoso@slind.org>
> 	Date:   Thu Jun 3 20:53:43 2010 +1000
> 
> 	crypto: testmgr - add an option to disable cryptoalgos' self-tests

Indeed this changeset is buggy.  It makes cryptomgr return a value
as if it was not loaded.  This triggers the module load.

I'll send you a patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
