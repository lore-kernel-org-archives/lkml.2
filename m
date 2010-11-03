Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0KCRue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:50:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57743 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0KCRua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E9cpMf+WqyRxJ/w3SDL3QoayG8IPHJP4ZHKck0E2JYEo4vVcGv8XByxCOh6rAtuLwd
         pYiaecKFpUWrLRpyvaE6/IawPWHQr4NijCVa29HkgFEcifrfJnflskbrlJh/uwSoUkjY
         EAqwh81l5JD3Ex7UAKIes+SpPKKFee7du5Iyc=
Subject: Re: [PATCH] drivers/net/tile/: on-chip network drivers for the
 tile architecture
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4CD19DCF.1040709@tilera.com>
References: <201011012107.oA1L7TGd031588@farm-0027.internal.tilera.com>
	 <20101103125959.3231daa1@s6510>  <4CD19DCF.1040709@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 18:50:22 +0100
Message-ID: <1288806622.2511.187.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 13:37 -0400, Chris Metcalf a écrit :
> Stephen, thanks for your feedback!
> 
> On 11/3/2010 12:59 PM, Stephen Hemminger wrote:
> > 1. MUST not use volatile, see volatile-considered-harmful.txt
> 
> The "harmful" use of volatile is in trying to fake out SMP.  Believe me,
> with a 64-core architecture, we know our SMP guidelines. :-)  Our use here
> is simply to force the compiler to issue a load, for the side-effect of
> populating the TLB, for example.
> 
> However, your response does suggest that simply the syntactic use of
> "volatile" will cause a red flag for readers.  I'll move this to an inline
> function in a header with a comment explaining what it's for, and use the
> function instead.

Please read Documentation/volatile-considered-harmful.txt

Then if there is a problem, we can make change to the documentation, but
volatile use in new code is _strictly_ forbidden.

ACCESS_ONCE() is your friend, we might document it in
Documentation/volatile-considered-harmful.txt



