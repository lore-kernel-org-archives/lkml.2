Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2EWBzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:55:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62833 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413Ab2EWBzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:55:04 -0400
Message-ID: <4FBC4372.5070000@gmail.com>
Date: Wed, 23 May 2012 11:54:58 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
CC: ext Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        apw@canonical.com
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com> <1337288048.17726.64.camel@joe2Laptop> <20120517211641.GC27953@pcarmody2.research.nokia.com>
In-Reply-To: <20120517211641.GC27953@pcarmody2.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/12 07:16, Phil Carmody wrote:

> On 17/05/12 13:54 -0700, ext Joe Perches wrote:
>>> +# check for deliberate avoidance of the above anti-typedef rule
>>> +		if ($line =~ /#\s*define\s+$Ident\s+$Type\b/) {
>>> +			WARN("NEW_TYPEDEFS",
>>> +			     "do not fake typedefs using #define\n" . $herecurr);
>>> +		}
>>> +
>>
>> I think the false positive rate is pretty high.
>> I used this and don't see too many I'd remove.
>>
>> $ git grep -E "#\s*define\s+\w+\s+(struct|unsigned|char|short|int|long|const)\b"
>>
>> Got an example you want this to find?
> 
> Too many. Alas I can't share them. 


That sounds like the cases you have seen are in code which is not
public. I don't think I have ever seen code in the kernel, or in
proposed patches which fakes a typedef with a #define.

Is this an issue for public code, or for a private company tree? In the
latter case, the checkpatch addition should go in your private tree,
rather than mainline. It looks like, at least for mainline Linux, you
are trying to solve a non-existent problem.

~Ryan
