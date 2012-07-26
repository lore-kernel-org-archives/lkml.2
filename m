Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2GZDRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 23:17:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33251 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2GZDRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 23:17:07 -0400
Message-ID: <5010B683.1010708@zytor.com>
Date: Wed, 25 Jul 2012 20:16:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org, DJ Johnson <dj.johnson@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 07/10] random: add new get_random_bytes_arch() function
References: <1341511933-11169-1-git-send-email-tytso@mit.edu> <1341511933-11169-8-git-send-email-tytso@mit.edu> <500F69F3.3040905@zytor.com> <20120725151000.GA30996@thunk.org>
In-Reply-To: <20120725151000.GA30996@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 08:10 AM, Theodore Ts'o wrote:
> Aside from whether it's better to do this step in
> xfer_secondary_pool() or extract_entropy() ...

By the way, I looked at doing this in xfer_secondary_pool()... the 
problem there is that xfer_secondary_pool() is called exactly once per 
invocation of extract_entropy() and so there is no way to make it inject 
the same amount of material as it consumes.

One could put it in extract_entropy[_user]() and if you prefer I'll 
rewrite the patch to do that, however that code would look very similar 
to the one in extract_buf() -- pretty much the same code in the caller 
rather than the callee -- but would have the same downside with being 
processed on 10-byte chunks because the final buffer might be misaligned 
and/or partial.  It would mean just running it once rather than twice 
per output datum, but I actually expected you would prefer the 
additional mashing and security margin.

	-hpa

P.S. Anyone who have any insider info on when we can expect the SHA-3 
selection?  Switching to SHA-2 at this time with SHA-3 around the corner 
(and based on numbers I have seen, likely to be faster) seems a bit silly...

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

