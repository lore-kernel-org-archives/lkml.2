Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0KLHcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:32:12 -0500
Received: from stinky.trash.net ([213.144.137.162]:55810 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0KLHcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:32:11 -0500
Message-ID: <4CDCED7A.9040202@trash.net>
Date: Fri, 12 Nov 2010 08:32:10 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Eric Paris <eparis@redhat.com>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: NF_HOOK_COND has wrong conditional
References: <20101111190954.29005.61686.stgit@paris.rdu.redhat.com> <alpine.LNX.2.01.1011112148100.30863@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1011112148100.30863@obet.zrqbmnf.qr>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.2010 21:49, Jan Engelhardt wrote:
> On Thursday 2010-11-11 20:09, Eric Paris wrote:
> 
>> The NF_HOOK_COND returns 0 when it shouldn't due to what I believe to be an
>> error in the code as the order of operations is not what was intended.  C will
>> evalutate == before =.  Which means ret is getting set to the bool result,
>> rather than the return value of the function call.  The code says
>>
>> if (ret = function() == 1)
>> when it meant to say:
>> if ((ret = function()) == 1)
> 
> Thanks for catching. Indeed (ret = f) == 1 is desired, as can be seen in 
> patch 2249065f4b22b493bae2caf549b86f175f33188e.

Applied, thanks Eric.
