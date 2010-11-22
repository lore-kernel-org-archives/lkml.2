Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab0KVSRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:17:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52927 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab0KVSR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:17:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OPaWwHMX1QNvHpbOmXm20a2EvpWZBdqnZVBTQa4jWHvHR7q01e/x2rHwrF/nt4Tkof
         NvriFdRONNittcL/U9koZBOwE0zdLJYWClgiy4COpP23PWBFP35qTMgU/AbjwnG2HRLS
         uDj7Uh/U89e+cT2Mnaqz7CtyAT4dAy9rmK664=
MIME-Version: 1.0
In-Reply-To: <20101122104312.23b6daea@lxorguk.ukuu.org.uk>
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
	<1290391175.2903.132.camel@yhuang-dev>
	<20101122104312.23b6daea@lxorguk.ukuu.org.uk>
Date: Mon, 22 Nov 2010 10:17:28 -0800
X-Google-Sender-Auth: c_pryRhUTqUpbEFjF5sI7RvS0pM
Message-ID: <AANLkTinxJ3uTRanOmc615V1_S5D1L4v_5vSjPYCzjf2Q@mail.gmail.com>
Subject: Re: [RFC] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 2:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > "writer" which writes a record with a type to the persistent store
>>
>> I think it is necessary to require this to be NMI safe (in comments?),
>> because hardware error handler may need to write to persistent storage
>> in NMI context. Or we can add a "flag" field to let storage provider
>> advocate its capability of NMI safe.
>
> One thing we need for some of the driver code sitting in the pending pile
> is support for hardware assisted logging, where record numberes are handed
> out by a device register access.

I don't follow you here ... perhaps we have a different idea
of what "record numbers" are?  I'm thinking they are purely
an internal implementation detail of a platform level pstore
driver ... but the generic code needs to use them as an
opaque object holding them from the result of a read and
using them when requesting an erase.  What usage are
you thinking of that needs this device register access?

>> > Once an error record has been viewed, analysed, saved. The
>> > user can request it to be cleared by writing its name to the
>> > "erase" file:
>
> How will fragmentation be handled ?

This is left as an exercise for the platform level diver (or
in the case of ERST, it is handled by the firmware that
implements ERST).  In general this shouldn't be a hard
problem because I think the usual use case will be that
just after boot we will run some processes that look at,
analyse, save and clear all the error records. Different
types of records may be handled by different processes,
so there can be some short term fragmentation when
one type of record has been erased, but the remainder
have not yet been processed.

>> > + * Erase records by writing their filename to the "erase" file. E.g.
>> > + *     # echo "dmesg-0" > erase
>
> rm dmesg-0
>
> We have a model for this and filesystem indirected via sysfs commands is
> in the daft category.

Yup - totally mad.  My sysfs-fu isn't up to figuring out how
to get a notification on unlink(2). Is that possible? It would
be a much superior metaphor.

-Tony
