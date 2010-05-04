Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0EDHem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:34:42 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:45373 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756631Ab0EDHek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:34:40 -0400
Message-ID: <4BDFCDFD.60402@euromail.se>
Date: Tue, 04 May 2010 09:34:21 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] input: mt: Simplify event bypass logic
References: <1272721779-2124-1-git-send-email-rydberg@euromail.se> <20100504064905.GB17482@core.coreip.homeip.net>
In-Reply-To: <20100504064905.GB17482@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O9CeC-0005Jz-5R.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1O9CeC-0005Jz-5R ba16d81629fd1bfeed5d6cc29f02f79a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Sat, May 01, 2010 at 03:49:39PM +0200, Henrik Rydberg wrote:
>> The input bypass mechanism is only used by the MT events. Since all
>> MT events use bypassing by construction, the current list is a mere
>> duplication of input.h. This patch replaces the bypass list by a
>> simple range test.
>>
> 
> Henrik,
> 
> I disagree with the patch. I can not guarantee that we will be able to
> maintain continuous range of ABS_MT_* events and thus current scheme is
> more flexible.
> 
> Thanks.
> 

Yes, I was hesitant myself. I would rather keep all [ABS_MAX + 1 - ABS_MT_MIN]
in the slot. Introduces a memory slack but is more flexible.

Henrik
