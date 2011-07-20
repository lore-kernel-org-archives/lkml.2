Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab1GTIaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 04:30:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48906 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936Ab1GTIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 04:30:45 -0400
Date: Wed, 20 Jul 2011 09:30:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: kmemleak fails to report detected leaks after allocation
 failure
Message-ID: <20110720083036.GG28726@e102109-lin.cambridge.arm.com>
References: <20110719211438.GA21588@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719211438.GA21588@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 10:14:38PM +0100, Nick Bowler wrote:
> I just ran into a somewhat amusing issue with kmemleak.  After running
> for a while (10 days), and detecting about 100 "suspected memory leaks",
> kmemleak ultimately reported:
> 
>   kmemleak: Cannot allocate a kmemleak_object structure
>   kmemleak: Automatic memory scanning thread ended
>   kmemleak: Kernel memory leak detector disabled
> 
> OK, so something failed and kmemleak apparently can't recover from
> this.  However, at this point, it appears that kmemleak has *also*
> lost the ability to report the earlier leaks that it actually
> detected.
> 
>   cat: /sys/kernel/debug/kmemleak: Device or resource busy
> 
> It seems to me that kmemleak shouldn't lose the ability to report leaks
> that it already detected after it disables itself due to an issue that
> was potentially caused by the very leaks that it managed to detect
> (unlikely in this instance, but still...).

Very good point, I haven't thought of this. I'll try to improve this
part.

Thanks.

-- 
Catalin
