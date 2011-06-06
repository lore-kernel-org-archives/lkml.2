Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1FFT4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:56:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37074 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab1FFTz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:55:59 -0400
Date: Mon, 6 Jun 2011 15:55:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: unlink(nonexistent): EROFS or ENOENT?
Message-ID: <20110606195555.GB20818@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <4DE26F97.9050607@msgid.tls.msk.ru>
 <20110606033949.GE7180@thunk.org>
 <4DED0AB3.6060708@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED0AB3.6060708@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 09:13:23PM +0400, Michael Tokarev wrote:
> Thank you for the answer.  I thought noone will reply... ;)
> 
> >> Just noticed that at least on ext4, unlinking a
> >> non-existing file from a read-only filesystem
> >> results in EROFS instead of ENOENT.  I'd expect
> >> it return ENOENT - it is more logical, at least
> >> in my opinion.

>   /* The unlinkat from kernels like linux-2.6.32 reports EROFS even for
>      nonexistent files.  When the file is indeed missing, map that to ENOENT,
>      so that rm -f ignores it, as required.  Even without -f, this is useful
>      because it makes rm print the more precise diagnostic.  */

OK, I see what's going on.  This check is in the VFS layer, so it
affects all filesystems; it's not an ext4-specific thing.

Patch coming shortly.

	    		      	     		   - Ted
