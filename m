Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2JTQjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:39:01 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58686 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2JTQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:39:00 -0400
Message-ID: <5082D3A1.1050001@linaro.org>
Date: Sat, 20 Oct 2012 10:38:57 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        kernel-team@android.com, john.stultz@linaro.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
References: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org> <20121005181608.GA24356@core.coreip.homeip.net> <506F3987.9020902@linaro.org> <CAMP5XgdtYQxu2cp6LC0Asi5ZyGL-ARnh0pvKDi7uNeZertaHSQ@mail.gmail.com>
In-Reply-To: <CAMP5XgdtYQxu2cp6LC0Asi5ZyGL-ARnh0pvKDi7uNeZertaHSQ@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-16 09:35 PM, Arve Hjønnevåg wrote:
> On Fri, Oct 5, 2012 at 12:48 PM, Mathieu Poirier
> <mathieu.poirier@linaro.org> wrote:
>> On 12-10-05 12:16 PM, Dmitry Torokhov wrote:
>>> On Fri, Oct 05, 2012 at 11:59:29AM -0600, mathieu.poirier@linaro.org wrote:
>>>> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
>>>>
>>>> Andrew,
>>>>
>>>> After requesting a number of changes that, to my understanding
>>>> have been implemented, I have not been able to get the attention
>>>> of the subsystem maintainer on this patch.
>>>>
>>>> If there are still issues, I'm open to making changes but I want
>>>> to make sure it doesn't get forgotten.  If there no objections,
>>>> would you consider queuint it ?
>>>
>>> Mathieu,
>>>
>>> I have the same objection as before: using platform device solely for
>>> the purpose of passing some data from board code to the driver. Surely
>>> there are other ways of passing this bit of data... What about, for
>>> example, making it an empty weak symbol so that board code could
>>> override it with strong one?
>>
>> Thanks for the comments - I will implement a weak function in the
>> keyreset driver.
>>
> 
> A weak symbol does not work. A single kernel can support multiple
> devices that have unique reset key combinations.
> 

I'm afraid Arve has a point here...  His comment about supporting
multiple combinations got me thinking and forced me to dive back in the
code.

The original keyreset driver can indeed be instantiated multiple times
while the sysrq driver is a one instance model.  In its current
implementation the keyreset extension can only support one reset sequence.

But does a system realistically need to support more than one reset
sequence ?

If so then I can enhance the keyreset extension of the sysrq driver but
that will also mean, as stated by Arve, that we will need to keep the
platform data.  On the flip side it is deemed sufficient to support a
single reset sequence then I'll implement the weak symbol method.

The subject is up for debate, please chime in with your opinion.

Mathieu.
