Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1FBNsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:48:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46409 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1FBNsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oJjBYVzzXzfMrOdt9esT2puOLfYkvA3zkuhtHAnBbsYkL8pJJpHucDj5my4f/6L12J
         DqRemVIhbTGamqA1XyCrBBE1TVWaxPob15BkwWpY/tk/tQim9+xJcCB9vM9fvjO2WDHq
         JLe8V4o+IFOGFcmggANvRyQVcVXciawpCFPSY=
MIME-Version: 1.0
In-Reply-To: <BANLkTimi2o4vnSWp5rQGrU3BTSC+YyO0qg@mail.gmail.com>
References: <1306957788-12310-1-git-send-email-wad@chromium.org>
	<BANLkTimi2o4vnSWp5rQGrU3BTSC+YyO0qg@mail.gmail.com>
Date: Thu, 2 Jun 2011 08:48:16 -0500
Message-ID: <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
Subject: Re: [PATCH] init: add root=PARTUUID=UUID+/-%d support
From: Will Drewry <wad@chromium.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 7:49 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, Jun 1, 2011 at 21:49, Will Drewry <wad@chromium.org> wrote:
>> Not sure if this is practical and/or interesting to others, but it's a
>> minimal change --
>>
>> Expands root=PARTUUID=UUID syntax to support selecting a root partition
>> by integer offset from a known, unique partition.  This approach
>> provides similar properties to specifying a device and partition number,
>> but using the UUID as the unique path prior to evaluating the offset.
>>
>> For example,
>>  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B+1
>> selects the partition with UUID 99DE.. then select the next
>> partition.
>>
>> This change is motivated by a particular usecase in Chromium OS where
>> the bootloader can easily determine what partition it is on (by UUID)
>> but doesn't perform general partition table walking.
>>
>> That said, support for this approach provides a direct mechanism for the
>> user to modify the root partition to boot without specifically needing
>> to extract each PARTUUID or update the bootloader explicitly when the
>> root partition UUID is changed (if it is recreated to be larger, for
>> instance, restored, etc).  Pinning to a /boot partition UUID with an
>> offset allows the arbitrary root partition reconfiguration/modifications
>> with slightly less ambiguity than just [dev][partition] and less
>> stringency than the specific root partition UUID.
>
> Kind of a creative notation to add/substract something from a uuid. :)

Necessity can sometimes do that :)

> If we are not sure we'll not need another magic thing in the future,
> we might want to go for a named parameter to add?
> Maybe instead of:
>  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B+2
> we could do:
>  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B,PARTNROFF=2
>
> Might be it's a but over the top, but the key is named PARTUUID, and a
> +- to it doesn't seem to explain what it does and can not really be
> expanded for even more creative uses. :)

Good call!  I'll take a pass at integrating that. I can see a couple
different ways of handling the parsing (e.g., when and what does it
affect).  Do you think it would make sense to keep it isolated to just
being a PARTUUID subargument or would it make more sense for
PARTNROFF= to be evaluated as a generic root= attribute?  I can see
benefits to both, but one is considerably more minimal to implement :)
 [Maybe I'll try both and see how they look.]

thanks!
