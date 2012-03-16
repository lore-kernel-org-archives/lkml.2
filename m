Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2CPTWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:22:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57849 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751544Ab2CPTWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:22:42 -0400
Message-ID: <1331925755.11368.14.camel@joe2Laptop>
Subject: Re: [PATCH 11/11] checkpatch: Check for spin_is_locked
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Fri, 16 Mar 2012 12:22:35 -0700
In-Reply-To: <1331924464-18023-12-git-send-email-andi@firstfloor.org>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
	 <1331924464-18023-12-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 12:01 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> spin_is_locked is usually misused. In checkpatch.pl
> - warn when it is used at all
> - error out when it is asserted on free, because that's usually broken
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +# spin_is_locked is usually misused. warn about it.
> +		if ($line =~ /\bspin_is_locked\s*\(/) {
> +			# BUG_ON/WARN_ON(!spin_is_locked() is generally a bug
> +			if ($line =~ /(BUG_ON|WARN_ON|ASSERT)\s*\(!spin_is_locked/) {
> +				ERROR("ASSERT_SPIN_IS_LOCKED",
> +				     "Use lockdep_assert_held() instead of asserts on !spin_is_locked\n"
> +				      . $herecurr);
> +			} else {
> +				WARN("SPIN_IS_LOCKED",
> +				     "spin_is_locked is very rarely correctly used. Please reconsider\n"
> +					. $herecurr)
> +			}
> +		}
> +

I suggest you use a single --ignore string of
"SPIN_IS_LOCKED" instead of different ones.

Grammar might be improved in the WARN.  Maybe:
"Using spin_is_locked() is generally wrong. See [foo documentation]\n"

Also, like what was done for yield(), perhaps
some kernel-doc content would be useful.

See -next commit 8e3fabfde445a872c8aec2296846badf24d7c8b4


