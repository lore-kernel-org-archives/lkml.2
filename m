Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030922Ab2CIUn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:43:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:32823 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030419Ab2CIUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:43:27 -0500
Message-ID: <4F5A6B6B.50703@wwwdotorg.org>
Date: Fri, 09 Mar 2012 13:43:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors
References: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org> <20120309203207.GB10835@windriver.com>
In-Reply-To: <20120309203207.GB10835@windriver.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 01:32 PM, Paul Gortmaker wrote:
> [[PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors] On 09/03/2012 (Fri 13:18) Stephen Warren wrote:
> 
>> Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
>> which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
>> <linux/bug.h>. Include that so that every .c file using the pinctrl macros
>> doesn't have to do that itself.
> 
> Which C files are failing?  The approach was to be adding it only
> for headers with static inlines which use it, and add it to C files
> that are actually *deploying* the macros.

For me, the files that are failing haven't been committed upstream yet;
I expect them to be very soon after the 3.4 merge window completes.

However, I expect you'll see this issue with arch/arm/mach-u300/core.c,
since it uses the same macros defined in pinctrl/machine.h that cause
the problem for me, unless one of the include files there picks up bug.h
already.

As a general statement though, once pinctrl becomes more widely adopted,
I expect to see many files start to use macros from pinctrl/machine.h,
and hence implicitly use ARRAY_SIZE(), and hence even more implicitly
depend on linux/bug.h. I don't think it's at all reasonable to force the
author of every one of those files to track down 3 or 4 levels of header
file dependencies to find that they need linux/bug.h even though they
make no direct use of its features, when it's known that almost any user
of pinctrl/machine.h is going to hit this issue.
