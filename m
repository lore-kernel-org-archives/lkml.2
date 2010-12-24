Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0LXSpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 13:45:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:37800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab0LXSpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 13:45:41 -0500
Message-ID: <4D14EA49.3070005@suse.com>
Date: Fri, 24 Dec 2010 13:45:29 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: taskstats alignment...
References: <20101223.093022.193727098.davem@davemloft.net>
In-Reply-To: <20101223.093022.193727098.davem@davemloft.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/23/2010 12:30 PM, David Miller wrote:
> 
> Re: commit 4be2c95d1f7706ca0e74499f2bd118e1cee19669
> 
> Pretty much every 64-bit architecture other than
> powerpc64 and x86-64 needs that code, not just
> IA64.
> 
> Better check would be:
> 
> CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> 
> Otherwise we'll be twiddling that ifdef endlessly as each
> and every other 64-bit platform bumps into this issue.
> 
> So please could you change this to use a more sane check?

I don't have an objection to it, but I've been pushing that we make the
change universal from the beginning of the discussion.

The issue is that it causes breakage on apps that aren't following the
interface properly. iotop, in particular, has hard-coded offsets into
the packet to fish out the taskstats structure.

So, if the goal of not breaking x86_64 is good enough, I'm fine with
this change.

- -Jeff


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0U6kgACgkQLPWxlyuTD7IqxACfVpl1BIlc/5RXbL4w1uF0meQE
3XMAoJTNbInYgNE5xJ41cZ3X9Jrr4cCX
=7e96
-----END PGP SIGNATURE-----
