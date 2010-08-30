Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0H3V1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:27:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58785 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab0H3V1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hmoIKux2juvm68vuge5M34oYABjPCbghZ64eOJ7qpR/wDBl5PkwJMaL+rC8tHM5r0P
         Ep1tw1pqFwNDQVKt6L6vWUX29gGVhWdCbGxrTaTrCZPDd7Bl9Mryo5RnBc7VIRs0B2DC
         ZE8elEDhF5Fpz3/28e+piNCNe6wuk6UBdrsRI=
MIME-Version: 1.0
In-Reply-To: <20100830102527.17d5e1f1.randy.dunlap@oracle.com>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	<i5fr6h$ih6$1@dough.gmane.org>
	<4C7BE3AE.8020204@suse.de>
	<AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
	<20100830102527.17d5e1f1.randy.dunlap@oracle.com>
Date: Mon, 30 Aug 2010 16:27:34 -0500
Message-ID: <AANLkTikqKG0Fp=BzXcBW9JCuLF07X6sbD8HVxWxqkRnD@mail.gmail.com>
Subject: Re: Linux 2.6.36-rc3
From: Steve French <smfrench@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sage Weil <sage@newdream.net>
Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Miguel Calleja <mcalleja1@telecable.es>,
        LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Shirish S Pargaonkar <shirishp@us.ibm.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:25 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 30 Aug 2010 12:14:53 -0500 Shirish Pargaonkar wrote:
>
>> On Mon, Aug 30, 2010 at 12:00 PM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
>> > (Cc linux-cifs@vger.kernel.org)
>> >
>> > Couldn't get a chance to check this, but I guess this is perhaps due to
>> > the recent crypto patches..
>>
>> Suresh, yes, cifs auth and signing code using kernel crypto (shash) apis.
>>
>> fs/cifs/Kconfig
>>
>>         select CRYPTO_MD5
>>         select CRYPTO_ARC4
>>
>
> Either CIFS should depend on CRYPTO:
> change
>        depends on INET
> to
>        depends on INET && CRYPTO
>
> or it can also select CRYPTO.
>
>>
>> >
>> > On 08/30/2010 02:17 PM, Miguel Calleja wrote:
>> >> CIFS does not build without CRYPTO selected.

OK - will fix this for cifs.   Looks like ecryptfs chose "depends on CRYPTO"
and ubifs chose "select CRYPTO" - but for network file system seems like
"select CRYPTO" (rather than depends on) makes more sense.

The ceph file system seems like it has the same type of problem.
fs/ceph/Kconfig
has "select CRYPTO_AES" but not "select CRYPTO"



-- 
Thanks,

Steve
