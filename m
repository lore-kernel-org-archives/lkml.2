Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0G1Asm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 20:48:42 -0400
Received: from mail.perches.com ([173.55.12.10]:2140 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0G1Asl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 20:48:41 -0400
Subject: Re: [PATCH 2/4] Checkpatch: prefer usleep_range over udelay
From: Joe Perches <joe@perches.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1280270347-4409-3-git-send-email-ppannuto@codeaurora.org>
References: <1280270347-4409-1-git-send-email-ppannuto@codeaurora.org>
	 <1280270347-4409-3-git-send-email-ppannuto@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 17:48:39 -0700
Message-ID: <1280278119.24054.66.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 15:39 -0700, Patrick Pannuto wrote:
> When possible, sleeping is (usually) better than delaying,
> however, don't bother callers of udelay < 10us, as those
> cases are not with the switch to usleep_range
> +# prefer usleep_range over udelay
> +		if ($line =~ /\budelay\s*\((.+)\);/) {
> +			# ignore udelay's < 10, however

This doesn't handle these cases:

	udelay(MY_DEFINED_DELAY)
	udelay( 100 )

Shouldn't this be:

		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
			WARN("usleep_range is preferred over udelay; see Documentation/timers/delays.txt\n" . $line);

Maybe these should be converted from WARN to CHK

