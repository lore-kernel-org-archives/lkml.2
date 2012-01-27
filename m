Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2A0XUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:20:31 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39302 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2A0XU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:20:27 -0500
Message-ID: <4F233188.2010307@gmail.com>
Date: Sat, 28 Jan 2012 10:21:44 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Joe Perches <joe@perches.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next V2] drivers: Use NULL not zero pointer assignments
References: <20120126061330.GA15856@elgon.mountain>  <1327559803.28707.6.camel@joe2Laptop> <1327642391.4846.36.camel@joe2Laptop>  <4F22421A.5020501@gmail.com> <1327649890.12089.20.camel@joe2Laptop> <4F2324EB.1030109@gmail.com> <alpine.DEB.2.02.1201272337580.1993@hadrien>
In-Reply-To: <alpine.DEB.2.02.1201272337580.1993@hadrien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/12 09:46, Julia Lawall wrote:
> On Sat, 28 Jan 2012, Ryan Mallon wrote:
>
>> On 27/01/12 18:38, Joe Perches wrote:
>>> On Fri, 2012-01-27 at 17:20 +1100, Ryan Mallon wrote:
>>>> On 27/01/12 16:33, Joe Perches wrote:
>>>>> Using NULL pointer assignments is more kernel-style standard.
>>>>> Uncompiled, untested.
>>>>> Done via cocinelle script:
>>>>> @@
>>>>> type T;
>>>>> T *pointer;
>>>>> @@
>>>>> -pointer = 0
>>>>> +pointer = NULL
>>>> Hi Joe,
>>> Hi Ryan.
>>>
>>>> I think you can drop a lot of the initialisations completely rather than
>>>> convert them. I've pointed some out below. I'm just scanning through for
>>>> likely candidates and I didn't bother looking at the staging drivers, so
>>>> this list is not comprehensive.
>>> I'll try a more generic solution.
>>> Here's a possible cocci script that looks for declarations with
>>> initializations that are later overwritten.
>>
>> I think you need to be careful with this. I don't know enough about Coccinelle, but in general control flow makes this a difficult problem. This are also the cases where a variable is assigned on all control paths before being used, but also has an (seemingly useless) initialiser because gcc occasionally cannot determine that the variable is always initialised (because in general it is undecidable) and so the initialisation is there to prevent a compiler warning.
>
> Coccinelle follows control-flow paths.  But it is not likely to be more clever about this than gcc.  It is unaware of the value of anything, so it does not realize that some control-flow paths are impossible.  So I don't think there would be big problems here.
>
>> There were also a couple of cases I pointed out where the assignment of zero to a pointer variable was actually masking some other bug, and so replacing the assignment with NULL, or removing the initialisation is not necessarily the correct fix.
>
> But in this case it doesn't seem like it would hurt?  Having 0 or NULL would probably not make someone more or less likely to think about the function as a whole?

The reason not to do this is because it is just code churn: Replacing broken code with code that is broken in a slightly different way is not particularly constructive.

>
> For example, in the container_of case, having NULL is probably better than 0, because someone else is more likely to look for container_of's of NULL than container_of's of 0.

Possibly, I think it should be obvious in either case though that the code is probably not correct and needs to be fixed correctly.

~Ryan

