Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab0HOBuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 21:50:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57272 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab0HOBuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 21:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tlVX0PbAwdK/iJ2YKtODoEtt1RjrU2UlX0lPJ7DNCpm4dw7nxvW6imeMFJ4jRtJjsL
         uYhleL3lukm7jjPZ2P0vyjXGOILgdFo0wrsCsdXAx2ttsk/kXZxa47eZTvIHjIO0hc8Y
         6A7LTcWe2a/jhmjFt8DXApLFqU5l2F1qxDB3A=
MIME-Version: 1.0
In-Reply-To: <AANLkTinJ04d2Bjuv2E4OOG=35TSHArEP6cHqGUQVUoy2@mail.gmail.com>
References: <AANLkTimnyXKahtjaFeSsgcq=xMy-pP3na1jidQhZ-dt2@mail.gmail.com>
	<AANLkTin2P5kcrC1SU-ANffSHyW8Ar4x4+qFuqVMFhYJE@mail.gmail.com>
	<AANLkTin-dksybH0ANypheovXXubwd+SRCpurdVRU7-Z=@mail.gmail.com>
	<1281726579.2810.10.camel@localhost.localdomain>
	<AANLkTinJ04d2Bjuv2E4OOG=35TSHArEP6cHqGUQVUoy2@mail.gmail.com>
Date: Sat, 14 Aug 2010 18:50:50 -0700
Message-ID: <AANLkTimOoQKm3mcPN4VSekoUkxkdJH7Ga2ma_xryGVF6@mail.gmail.com>
Subject: Re: Proposal: Use hi-res clock for file timestamps
From: Bret Towe <magnade@gmail.com>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 1:53 PM, Patrick J. LoPresti <lopresti@gmail.com> wrote:
> On Fri, Aug 13, 2010 at 12:09 PM, john stultz <johnstul@us.ibm.com> wrote:
>>
>> So other then "show some numbers", my only thought that might make the
>> patch more attractive is that rather than a global change, or a static
>> CONFIG_ option, would it maybe make more sense as a mount option?
>
> I really like this idea.
>
> Consider the following "revision 2" of my proposal:
>
> 1) Add a function pointer "current_fs_time" to struct super_block.
>
> 2) Replace all calls of the form:
>
>    current_fs_time(sb);
>
> with
>
>  sb->current_fs_time(sb);
>
>  3) Arrange for the default value to point to the current implementation.
>
> These first three could be one patch.  They change no functionality;
> they just enable the next step.
>
> Finally:
>
>  4) Add a mount option to cause sb->current_fs_time(sb) to use the
> hi-res implementation.
>
> Comments?

I'm not sure how nfs works but if this is a client side issue I don't
see anything wrong
with a CONFIG_ item but if its server side it might be better off as a
procfs or sysfs tunable
so reboots are not required to change the setting

performance wise why would there be any difference the same amount of
bits are being set on the disk drive no?
