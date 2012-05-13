Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2EMXdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:33:35 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37503 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2EMXdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:33:33 -0400
Message-ID: <4FB044A6.7090108@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 05:02:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
References: <1336515735.2097.23.camel@shrek.rexursive.com> <4FAA2673.50007@linux.vnet.ibm.com> <1336560579.2097.32.camel@shrek.rexursive.com> <aba7b996-df0e-420c-b2eb-d32881660fe8@email.android.com>
In-Reply-To: <aba7b996-df0e-420c-b2eb-d32881660fe8@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12051323-4790-0000-0000-000002AE567E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 04:41 PM, Bojan Smojver wrote:

> Bojan Smojver <bojan@rexursive.com> wrote:
> 
>> Honest answer - I have absolutely no idea. I've seen the code of
>> suspend-utils (i.e. user mode stuff) and it seems to me that it does
>> exactly this. Could be wrong of course, just like many times before.
> 
> What makes me think that this may not be that bad is the fact that

> post-resume, it will actually be hibernation code that will be unwinding

> things. So like this: prepare for hibernation, create image, suspend to

> memory 


This is the point where your patch gets scary - Suspend is not carried out
in its fullest sense; instead you jump directly to suspend_devices_and_enter().
Luckily, most of the things that happen before this are common between
suspend and hibernation. However, one thing that really stands out is the
notifications: if you directly call suspend_devices_and_enter(), we end
up missing the PM_SUSPEND_PREPARE notifications.

And there is no guarantee that everybody implements the same thing for
both PM_SUSPEND_PREPARE and PM_HIBERNATION_PREPARE notifications. That is
the reason I don't think it is safe.

> (equivalent to hibernation failure of some kind, really), resume

>from memory, unwind from unsuccessful hibernation.
> 
> No?
> 


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

