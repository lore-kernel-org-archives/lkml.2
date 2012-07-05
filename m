Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2GEP4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:56:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54186 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2GEP4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:56:53 -0400
Message-ID: <4FF5B942.6080101@wwwdotorg.org>
Date: Thu, 05 Jul 2012 09:56:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pwm: fix used-uninitialized warning in pwm_get()
References: <1341347661-26567-1-git-send-email-swarren@wwwdotorg.org> <20120704055828.GC18779@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120704055828.GC18779@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 11:58 PM, Thierry Reding wrote:
> On Tue, Jul 03, 2012 at 02:34:21PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>> 
>> This fixes: drivers/pwm/core.c: In function 'pwm_get': 
>> drivers/pwm/core.c:534:15: warning: 'index' may be used
>> uninitialized in this function
>> 
>> The addition to the if condition at end of the function isn't
>> strictly necessary to solve the warning, but does make it more
>> obvious that the initialization of "index" to a dummy value isn't
>> just hiding the problem.
> 
> Actually this seems to be a false positive, and one that I don't
> see (I use GCC 4.6.3). index will be initialized when chip is set
> in the loop. My guess is that GCC 4.6.3 actually notices while your
> version doesn't.

Yes, it is a false-positive, which is why I was fine with just
initializing the variable to hide the warning rather than making some
other code change. I think there's still value in hiding the warning
though, so that:

a) Nobody else has to look at the warning and decide it's a false
positive and remember to ignore it.

b) The fewer warnings there are, the more likely new warnings will be
noticed and analyzed.

So I'd still argue for this change, or some other fix for the warning,
be merged.
