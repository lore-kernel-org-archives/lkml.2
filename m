Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2CLUzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:55:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55488 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2CLUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:55:44 -0400
Message-ID: <4F5E62CC.6030002@wwwdotorg.org>
Date: Mon, 12 Mar 2012 14:55:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: Include <linux/bug.h> to prevent compile errors
References: <1331324305-1649-1-git-send-email-swarren@wwwdotorg.org> <CACRpkdbkoahUiB01srfBzm1Qh2RQPw5P6BjmouuLETAqfQY6_Q@mail.gmail.com>
In-Reply-To: <CACRpkdbkoahUiB01srfBzm1Qh2RQPw5P6BjmouuLETAqfQY6_Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 01:44 PM, Linus Walleij wrote:
> On Fri, Mar 9, 2012 at 9:18 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
>> which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
>> <linux/bug.h>. Include that so that every .c file using the pinctrl macros
>> doesn't have to do that itself.
> 
> I get this part...
...
>> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
...
>> -#include "pinctrl-state.h"
> 
> ?
> 
>> +#include <linux/bug.h>
>> +
>> +#include "pinctrl.h"
> 
> ?
> 
> But I moved the states out of machine.h and pinctrl.h just so
> that we shouldn't have to include pinctrl.h into machine.h?

Oops. Looks like I completely screwed up a rebase there.

If Paul acks the concept of the patch, I'll repost.
