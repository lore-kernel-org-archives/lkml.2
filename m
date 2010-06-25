Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0FYNeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:34:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45386 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab0FYNea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S/0i7+ZG1EZyb5SR484+KTk5cuNd5kYrnbUEEjycJDgleMfAedVBtIPqfFn6+EgDrc
         mE/wJNmtjk/DSodf+vtOdBoPYi9w9gPSW502J9LofP72BBy6VEnMOn/gytkOFja/7Zf2
         iFOX4PFgrNGXmH+qvz4bbGjM5OFrN4GkvfvuQ=
MIME-Version: 1.0
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B3553F63@dbde02.ent.ti.com>
References: <0680EC522D0CC943BC586913CF3768C003B3553D0C@dbde02.ent.ti.com>
	<4C235523.6000204@jic23.retrosnub.co.uk>
	<0680EC522D0CC943BC586913CF3768C003B3553F63@dbde02.ent.ti.com>
Date: Fri, 25 Jun 2010 15:34:28 +0200
Message-ID: <AANLkTilljwEFE9Yuf_bd6p_9P4Ck0VFa6bglyD45n5lz@mail.gmail.com>
Subject: Re: [PATCH] BMP085 : Change the macro to swap
From: Christoph Mair <christoph.mair@gmail.com>
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 3:00 PM, Datta, Shubhrajyoti
<shubhrajyoti@ti.com> wrote:
>
>
>> -----Original Message-----
>> From: J.I. Cameron [mailto:jic23@hermes.cam.ac.uk] On Behalf Of Jonathan
>> Cameron
>> Sent: Thursday, June 24, 2010 6:23 PM
>> To: Datta, Shubhrajyoti
>> Cc: linux-kernel@vger.kernel.org; Christoph Mair; Andrew Morton
>> Subject: Re: [PATCH] BMP085 : Change the macro to swap
>>
>> On 06/24/10 13:41, Datta, Shubhrajyoti wrote:
>> >
>> > Changing the macro to swap the bytes as the reason that the first byte
>> is the MSB and the next is LSB.
>> Are you sure on this one?
>
> The datasheet says the  E2PROM has the bytes as described in the comment below
> *
> * BMP085 Reg Addr
> * parameter     |       MSB     |       LSB
> * AC1           |       0xAA    |       0xAB
> ...
>
> AA has MSB and AB has lsb so it has to be swapped. My idea is that it does not depend on the endianness of the CPU running the code. So I think that swap should happen unconditionally. The I2C reads a string of bytes and the first byte from AA and next from AB and hence an unconditional swap maybe needed.
>
> Am I missing something.
The data is read bytewise and stored in memory starting with
MSB-LSM-MSB-LSB-... If you have a big endian CPU, it expects a 16 Bit
word to be stored in exactly this format. A little endian CPU expects
the LSB to be stored at the lower memory address: LSB-MSB.
Therefore the bytes have to be swapped only for little-endian cpus.

Best regards,
  Christoph
