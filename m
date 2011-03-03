Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab1CCS01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:26:27 -0500
Received: from nm.newmedia-net.de ([217.113.179.122]:35348 "EHLO
	webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598Ab1CCS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:26:26 -0500
X-Greylist: delayed 1130 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 13:26:26 EST
Message-ID: <4D6FD8E5.9080505@newmedia-net.de>
Date: Thu, 03 Mar 2011 19:07:33 +0100
From: Christian Scheele <scheele@newmedia-net.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Harald Welte <laforge@gpl-violations.org>,
        Armijn Hemel <armijn@gpl-violations.org>
CC: Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: Re: changing EXPORT_SYMBOL_GPL to EXPORT_SYMBOL in DD-WRT
References: <1299164159.10725.19.camel@hibbert> <20110303152349.GL8117@prithivi.gnumonks.org> <4D6FCA08.1080705@dd-wrt.com>
In-Reply-To: <4D6FCA08.1080705@dd-wrt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi alltogether,

http://svn.dd-wrt.com:8000/changeset/16371
http://svn.dd-wrt.com:8000/changeset/16372

we discussed this internally and found a solution that does not need 
this change anymore.

The problematic code did not end up in any distributed binary.

Thanks for bringing this issue to our attention.

If you have any further comments or question, please don't hesitate to 
contact me.

-- 
Mit freundlichen Grüssen / Regards

Christian Scheele

NewMedia-NET GmbH
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.newmedia-net.de / http://www.dd-wrt.com
email: scheele@newmedia-net.de
Tel.: +496251-582650 / Fax: +496251-5826565

On 22.07.64 20:59, Sebastian Gottschall (DD-WRT) wrote:
> The Problem source is easy. i migrated a new compiler which is Linaro
> 4.5.2 and this compiler inlines various function which have been not
> inlined in my previous compiler which was 4.3.3
> so i was running into this symbol problems newly today with the Atheros
> 802.11n LSDK Driver.
> For example. the symbol init_uts_ns is declared as GPL only. originally
> a function was used which returned this symbol. this worked in the past.
> but since this function is marked as inline, the symbol is now directly
> compiled into
> the driver which raised a compile problem.
>
> we are also migrating to ath9k in background, but we still need to
> develop alot of features to ath9k until we can use it as our current
> modified LSDK driver.
> so i needed to work around this problem today, to keep everything
> working in my sourcetree
>
> i hope you understand the problem in my side. it would remain just as
> temporarily solution until i fixed that problem in another way.
> for the init_uts_ns problem there is a solution right now. but for the
> crypto api i'm still looking for. normally i can avoid this by removing
> the soft crypto code which isnt used by newer hardware
> but for backward compatiblity with older chipsets, they need to remain
>
> regards,
> Sebastian Gottschall
> Am 03.03.2011 16:23, schrieb Harald Welte:
>> Hi Sebastian, Armijn and others,
>>
>> I can only follow what Armijn has been writing.
>>
>> On Thu, Mar 03, 2011 at 03:55:59PM +0100, Armijn Hemel wrote:
>>> I noticed that a few hours ago you changed a few lines in the kernel
>>> source of DD-WRT, changing the export from a few symbols from 'GPL only'
>>> to something a lot more permissive:
>> While the ideas and thoughts regarding the legal implications of
>> EXPORT_SYMBOL_GPL are wide (see e.g.http://lwn.net/Articles/154602/) and there
>> is no precedent as far as I know, there seems general consensus that it _at
>> least_ signifies the explicit intent of the author.
>>
>> By using the _GPL variant, the author unmistakingly indicates:
>> "I consider any use of that symbol to create a derivative work which must again
>>   be licensed under GNU GPL"
>>
>> So by modifying a _GPL symbol into the non-GPL variant (and using the code from
>> a non-GPL module), one would clearly violate the intent of the original author.
>> Whether or not that intent of the author is grounded in copyright law may
>> depend on the specific jurisdiction, circumstances and the judge that would
>> make up his mind about it, if such a case ever went to court.
>>
>> I would be interested to hear what DaveM, James Morris and Herbert Xu
>> as the authors of the files in question have to say about such activity.
>>
>> Regards,
>> 	Harald
>
>
> --
> Mit freundlichen Grüssen / Regards
>
> Sebastian Gottschall / CTO
>
> NewMedia-NET GmbH - DD-WRT
> Firmensitz:  Berliner Ring 101, 64625 Bensheim
> Registergericht: Amtsgericht Darmstadt, HRB 25473
> Geschäftsführer: Peter Steinhäuser, Christian Scheele
> http://www.dd-wrt.com
> email:s.gottschall@dd-wrt.com
> Tel.: +496251-582650 / Fax: +496251-5826565
>
>
