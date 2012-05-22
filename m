Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2EVHLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:11:55 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58716 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2EVHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:11:54 -0400
Message-ID: <4FBB3C35.1040104@linux.vnet.ibm.com>
Date: Tue, 22 May 2012 09:11:49 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com> <1337624236.5476.16.camel@marge.simpson.net>
In-Reply-To: <1337624236.5476.16.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12052207-3548-0000-0000-000001FC0842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/21/2012 08:17 PM, Mike Galbraith wrote:
> On Mon, 2012-05-21 at 17:45 +0200, Martin Schwidefsky wrote:
>> our performance team found a performance degradation with a recent
>> distribution update in regard to fair sleepers (or the lack of fair
>> sleepers). On s390 we used to run with fair sleepers disabled.
>>
>> We see the performance degradation with our network benchmark and fair
>> sleepers enabled, the largest hit is on virtual connections:
>
> I can see you wanting the feature back.  You guys apparently do not
> generally run mixed loads on your boxen, else you wouldn't want to turn
> the scheduler into a tick granularity scheduler, but why compile time?
> If the fast path branch isn't important, and given it only became
> important while I was trying to scrape a few cycles together, why not
> just restore the feature as it used to exist under the pretext that you
> need it, and others may as well, so we eat the branch in the interest of
> general flexibility, and call removal a booboo?
>
> -Mike
>

If "eating the branches" is fine for everyone s390 can surely live with 
it. The intention to make it configurable, was to allow systems that 
really never want it, to be still able to avoid the branch.

By that everyone can configure it the way they want it and we avoid 
another modification of the same code over and over again.


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance

