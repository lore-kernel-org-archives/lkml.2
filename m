Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab0JFS2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:28:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50368 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab0JFS2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=iGTHR6PXqhzTLFuKXDY+79vW/iUtjjwhTa7qKIi0ZAndutkD+peOEQvf8jt3idmgXd
         jI4AYJgalxcTW7WhFmBl/p1qqbku+VHS8qGvben0x2s7dBzmzAdQzfJUEnHeXJhlRqrr
         vfKLiwLu4kKFGPX8RP38Y2eXCm1Um83sPP73g=
MIME-Version: 1.0
In-Reply-To: <1286387660.3655.382.camel@jlt3.sipsolutions.net>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
 <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
 <1286349552.6145.11.camel@aeonflux> <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
 <20101006173949.GG7070@tux> <1286387660.3655.382.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 6 Oct 2010 11:22:13 -0700
X-Google-Sender-Auth: dOSbNzIXDRzH3mCC2I9Rh3ihSSg
Message-ID: <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
Subject: Re: RFC: btusb firmware load help
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 10:54 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-10-06 at 10:39 -0700, Luis R. Rodriguez wrote:
>
>
>> > With sflash based AR3011 hardware, when we connect the device to USB
>> > port it gets detected as a Bluetooth device because of firmware in
>> > Flash (VID=0x0CF3, PID=0x3002). This triggers the Bluetooth sub
>> > system driver (btusb.ko) directly in the host instead of ath3k
>> > DFU driver. Therefore, there is no firmware downloaded in to the
>> > RAM to bring up Bluetooth at this point. This is the problem
>> > we're trying to "fix".
>
> So the easiest fix for this would be to
>  a) ignore 0x0cf3,0x3002 in btusb
>  b) add it to ath3k firmware loading
>  c) change the ath3k firmware to load with 0x0cf3,0x3003 (or whatever
>    else you want, as long as it's not 0x3000 and not 0x3002)
>
> Then the ignore in btusb won't affect ath3k after that new firmware was
> loaded.

Good idea, I forgot about possible firmware changes :) Lets see if our
team can do that. Thanks for all the feedback.

  Luis
