Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1AFNz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:55:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39144 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1AFNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:55:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w4aq6TNMm2brBIa7TU3KPXt9dXsbjBJebnhzuhKrMxv6CxpoabL6ndRvI9nHw02ifP
         2DFGZbcl2VBTD/qBfo7XhjZUl25cD4Q+tyB8ewu8F4c9XDceTX+fz6OWTPAlEoFLdENd
         8WZAOZosSL4lugOjyWF+HAtBWswENSKBTBhmM=
Message-ID: <4D25C9F5.1060907@lwfinger.net>
Date: Thu, 06 Jan 2011 07:56:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
References: <20110104123824.GA31557@gondor.apana.org.au> <20110104125722.GC27114@darkside.kls.lan> <20110104224238.GA4978@gondor.apana.org.au> <20110104230644.GJ27114@darkside.kls.lan> <20110105003020.GA5751@gondor.apana.org.au> <20110105035222.GA8762@darkside.kls.lan> <20110105054735.GA7773@gondor.apana.org.au> <20110105131621.GA24769@darkside.kls.lan> <20110106061241.GA18939@gondor.apana.org.au> <20110106131516.GB8803@darkside.kls.lan> <20110106133541.GA22030@gondor.apana.org.au>
In-Reply-To: <20110106133541.GA22030@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 07:35 AM, Herbert Xu wrote:
> On Thu, Jan 06, 2011 at 02:15:16PM +0100, Mario 'BitKoenig' Holbe wrote:
>>
>> The patch helps. No crashes, meaningful random data - perfect.
>> I still have 2 small annotations...
> 
> Thanks for testing!
> 
>> 1. Having ECX on the clobber-list is not really necessary.
>> XSTORE doesn't touch ECX at all.
>> REP XSTORE would touch it, but for this ECX would be an input anyways.
> 
> The documentation wasn't clear whether ECX would be updated without
> the REP prefix so I included it to be on the safe side.  Unfortunately
> my only VIA machine is on another continent at the moment so I can't
> test it myself.  Can you verify that ECX isn't changed without the
> REP prefix?
> 
>> 2. Would you mind doing the same for EDX as you did for EDI?
>> This doesn't really change anything currently, but will probably help
>> avoiding a debug-session like ours somewhere in the future :)
> 
> According to my documentation EDX isn't be modified (nor would it
> make sense as it would break REP XSTORE).  Are you seeing anything
> different?

As an interested observer, I think this routine needs some really detailed comments.

Larry
