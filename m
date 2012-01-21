Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2AUOB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 09:01:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57039 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2AUOB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:01:26 -0500
MIME-Version: 1.0
In-Reply-To: <4F1AC33E.90405@gmx.de>
References: <1327094732-9050-1-git-send-email-Julia.Lawall@lip6.fr>
 <1327094732-9050-3-git-send-email-Julia.Lawall@lip6.fr> <4F1AC33E.90405@gmx.de>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Sat, 21 Jan 2012 15:00:46 +0100
Message-ID: <CAOLZvyGujvpnCFxe7x82Y91kRRNM1-P165jMXXWryFqY3g-RXw@mail.gmail.com>
Subject: Re: [PATCH 2/4] drivers/video/au*fb.c: use devm_ functions
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 21, 2012 at 2:53 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> [CC'ing Manuel Lauss as he knows those drivers better than I do]
>
> On 01/20/2012 09:25 PM, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> The various devm_ functions allocate memory that is released when a driver
>> detaches.  This patch uses these functions for data that is allocated in
>> the probe function of a platform device and is only freed in the remove
>> function.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>> In the case of au1100fb.c, should the failed label return something other
>> than 0?
>> In the case of au1200fb.c, should the error-handling code under the new
>> call to dma_alloc_noncoherent jump to failed, like the other error handling
>> code?  I was not sure that there was actually anything for failed to do at
>> this point in the function.
>
> Maybe Manuel is able to answer these questions. I've queued this patch and if he
> doesn't respond I'll apply it after some time.

au1100fb:  Yes, a -ENODEV instead of 0 in the error case is probably a
good idea.
au1200fb:  The error path(s) are buggy; they don't free all windows if
creation of
                      the 4th fails for example. It has been this way
since the driver appeared
                      but for all current use cases (demoboards and in
the field) it actually works.
                      I'm working on a rewrite which is however
progressing rather slowly.


>>  drivers/video/au1100fb.c |   30 +++++++++++-------------------
>>  drivers/video/au1200fb.c |    9 +--------
>>  2 files changed, 12 insertions(+), 27 deletions(-)

Acked-by: Manuel Lauss <manuel.lauss@googlemail.com>

[...]

Thanks!
      Manuel Lauss
