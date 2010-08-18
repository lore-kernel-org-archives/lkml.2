Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0HRTse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:48:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45682 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0HRTsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:48:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6078"; a="51465348"
Message-ID: <4C6C3910.80800@codeaurora.org>
Date: Wed, 18 Aug 2010 12:48:32 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
References: <4C61EE55.5030506@codeaurora.org> <1282094950-6184-1-git-send-email-sboyd@codeaurora.org> <201008181428.45029.arnd@arndb.de>
In-Reply-To: <201008181428.45029.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 05:28 AM, Arnd Bergmann wrote:
> On Wednesday 18 August 2010, Stephen Boyd wrote:
>>
>> I'm unsure what needs to be done for the follow up patch. Shouldn't
>> it be multiple patches sent to each arch maintainer to fix the
>> wording?
>
> No, that will just result in half of them applying it, best make
> a single patch and send it to linux-arch@vger.kernel.org for review.
>
> It's probably best to move the config option to lib/Kconfig.debug
> so it only appears once, and make it depend on DEBUG_USER_COPY_CHECKS,
> which is then unconditionally defined by the architectures that want it.

Ok.

So the only sticking point now is that x86, parisc, and arm use warnings 
and errors but s390 only uses warnings. I guess I'll reword it to be:

	Enabling this option turns a certain set of sanity checks for
	user copy operations into compile time warnings/errors.

	The copy_from_user() etc checks are there to help test if there
	are sufficient security checks on the length argument of the
	copy operation, by having gcc prove that the argument is
	within bounds.

	If unsure, or if you run an older (pre 4.4) gcc where this
	option is a no-op, say N.

or I'll add a patch to make s390 trigger an error when this is enabled?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
