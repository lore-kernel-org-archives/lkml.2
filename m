Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab0IGOty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:49:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34259 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0IGOts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TNHCNFzSnnm+g92XXDgSMfcHDtDzs8YExoz+FEMPoyJGgItEaOrkeuIlLbqORAd1Mu
         TepfgK5j6BX5AAzlOp2FL/9tK+1wAgsFA5BmicXrPqH9c/I+INS1a0e7UUkR1C8Je4PK
         MJzNfTcYmOuH0628d6qJGjjOlw2AqfpKQFx8w=
MIME-Version: 1.0
In-Reply-To: <20100907141112.GB6903@gondor.apana.org.au>
References: <20100907084213.GA4610@gondor.apana.org.au>
	<20100907140646.GA31921@infradead.org>
	<20100907141112.GB6903@gondor.apana.org.au>
Date: Tue, 7 Sep 2010 16:49:46 +0200
X-Google-Sender-Auth: Odqd8nBfq3SK9sPo-PpsF90Qt8Y
Message-ID: <AANLkTikWRewCXdq3eeBMRQr3Ke7C2q42jnKqbKVwwpCH@mail.gmail.com>
Subject: Re: RFC: Crypto API User-interface
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 4:11 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:

>> > This is what I am proposing for the Crypto API user-interface.
>>
>> Can you explain why we would ever want a userspace interface to it?
>>
>> doing crypto in kernel for userspace consumers sis simply insane.
>> It's computational intensive code which has no business in kernel space
>> unless absolutely required (e.g. for kernel consumers).  In addition
>> to that adding the context switch overhead and address space transitions
>> is god awfull too.
>>
>> This all very much sounds like someone had far too much crack.
>
> FWIW I don't care about user-space using kernel software crypto at
> all.  It's the security people that do.

Then I'd suggest to not enforce your design over to people who have
thought and have interests on that. The NCR api which you rejected
(for not supporting kernel keyring - which your design also doesn't!),
has specific security goals and protects against specific threats.
This design here has been proposed by you quite many times in the past
and neither you, nor anyone else bothered implementing it. Now we have
two working implementations that offer user-space access to crypto
operations, (the openbsd cryptodev port), and NCR, but you discard
them and insist on a different design. Maybe yours is better (you have
to argue about that)... Probably I'd use it if it was there, but it
isn't.

regards,
Nikos
