Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab0JHNdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:33:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44972 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0JHNdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=scyEmN2caEVE2LjffF5IJ6D/H1wr5dr0Df6JamLi7I+O8LUtA+HVRYkNGaMAVTN/Qq
         pwwQoCasV3CmI9PfvBE3XNrT0ASltcehFI7lJR1MfTrvOgJS873VZlZY4hfAY3kY7vG0
         ZQXs1/WFgDXdO6J14b9Hxx0v/RrBTF8K04OnM=
MIME-Version: 1.0
In-Reply-To: <20101008130916.GC5327@balbir.in.ibm.com>
References: <20101005124521.GA2602@darkstar>
	<20101008130916.GC5327@balbir.in.ibm.com>
Date: Fri, 8 Oct 2010 21:33:02 +0800
Message-ID: <AANLkTimd2Z3Yy9yxHZA6raeFxp6L7Wtvy5rLSrMyjEU1@mail.gmail.com>
Subject: Re: [PATCH] kvm: add oom notifier for virtio balloon
From: Dave Young <hidave.darkstar@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 9:09 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Dave Young <hidave.darkstar@gmail.com> [2010-10-05 20:45:21]:
>
>> Balloon could cause guest memory oom killing and panic.
>>
>> Add oom notify to leak some memory and retry fill balloon after 5 minutes.
>>
>> At the same time add a mutex to protect balloon operations
>> because we need leak balloon in oom notifier and give back freed value.
>>
>> Thanks Anthony Liguori for his sugestion about inflate retrying.
>> Sometimes it will cause endless inflate/oom/delay loop,
>> so I think next step is to add an option to do noretry-when-oom balloon.
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Won't __GFP_NORETRY prevent OOM? Could you please describe how you
> tested the patch?

I have not tried __GFP_NORETRY, it should work, but balloon thread
will keep wasting cpu resource to allocating.


To test the patch, just balloon to small than minimal memory.

I use "balloon 30" in qemu monitor to limit slackware guest memory
usage. The normal memory used is ~40M.

Actually we need to differentiate the process which caused oom. If it
is balloon thread we should just stop ballooning, if it is others we
can do something like this patch, e.g. retry ballooning after 5
minutes.
>
> --
>        Three Cheers,
>        Balbir
>



-- 
Regards
dave
