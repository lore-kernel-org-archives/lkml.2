Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0C2Krx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:47:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab0C2Krj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:47:39 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] Allow Intel platforms to declare unsynchronized TSC to kernel
From: Andi Kleen <andi@firstfloor.org>
References: <20100324053257.GA4088@basil.fritz.box>
	<87zl1r7eod.fsf@basil.nowhere.org> <4BB07636.7010708@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 12:47:34 +0200
In-Reply-To: <4BB07636.7010708@jp.fujitsu.com> (Hidetoshi Seto's message of "Mon, 29 Mar 2010 18:43:18 +0900")
Message-ID: <87oci776bd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> (2010/03/29 16:46), Andi Kleen wrote:
>> Andi Kleen <andi@firstfloor.org> writes:
>> 
>>> Allow Intel platforms to declare unsynchronized TSC to kernel
>>>
>>> [This came out of a private discussion with Linus last week]
>> 
>> Ping?  Please review this patch.
>> 
>> -Andi
>
> Does "constant" implicitly means "synchronized"?

Yes it does for the CPUID bit.

> Following commit tells us that there could be
> "constant-but-unsynchronized TSC":
>  6c56ccecf05fafe100ab4ea94f6fccbf5ff00db7
>> So, reenable TSC sync test even on constant and non-stop TSC systems.

First the platform is supposed to clear in this case and when it
doesn't the later check catches it anyways.

BTW all the things you're mentioning are not actually changed by my
patch. In this regard it behaves the same as before. I don't think
the patch description has to describe things it does not change
or be a general tutorial on TSCs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
