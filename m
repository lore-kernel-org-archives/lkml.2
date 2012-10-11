Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2JKG3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:29:22 -0400
Received: from 1wt.eu ([62.212.114.60]:32776 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab2JKG3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:29:20 -0400
Date: Thu, 11 Oct 2012 08:29:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Romain Francoise <romain@orebokech.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, hpa@zytor.com
Subject: Re: Linux 2.6.32.60
Message-ID: <20121011062916.GG8938@1wt.eu>
References: <20121009094453.GA4289@1wt.eu> <87y5jeqv6b.fsf@silenus.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5jeqv6b.fsf@silenus.orebokech.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Romain,

On Wed, Oct 10, 2012 at 04:05:32PM +0200, Romain Francoise wrote:
> Hi Willy,
> 
> Willy Tarreau <w@1wt.eu> writes:
> 
> > I've just released Linux 2.6.32.60.
> 
> > This release contains, among others, a number of fixes for random and NTP,
> > including for the NTP leap second bug. Users should upgrade.
> 
> I'm somewhat surprised to see that it also includes a new feature, namely
> support for Intel's new RDRAND instruction to get random bits ("Bull
> Mountain"):
> 
> 67c1930 ("x86, random: Verify RDRAND functionality and allow it to be disabled")
> 5e6321d ("x86, random: Architectural inlines to get random integers with RDRAND")
> 
> This was apparently backported from 3.2 via Paul's 2.6.34 tree. Did you
> test this release on a CPU with RDRAND? The commits are small, but they
> don't really qualify as bugfix-only...

I agree they're not bugfix only, however they contribute to addressing a
real issue with random number generation that was raised this summer. As
you might be aware, it was found that many hosts on the net use the same
private SSH or SSL keys due to too low entropy when these keys are generated.
This explains why the random patches were backported in order to collect
more entropy from available sources. RDRAND certainly qualifies as a source
of entropy and I judged it was appropriate for a backport for this reason.
Nobody has objected about this during the review, but maybe you have a
different opinion and valid reasons for these patches to be reverted ?

> In v3.0-stable the various changes to mix more randomness in the entropy
> pool were backported without this feature.

Indeed, I didn't notice they weren't in 3.0 since I found them in 2.6.34. I
always try to ensure that users don't experience regressions when upgrading
to the next stable version.

If you think these patches constitute a regression, I can revert them.
However I'd like convincing arguments since they're here to help address
a real issue.

Regards,
Willy

