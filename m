Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0JRSqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:46:52 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3195 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab0JRSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:46:50 -0400
Date: Mon, 18 Oct 2010 15:46:28 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Jon Maloy <jon.maloy@ericsson.com>
Cc: davem@redhat.com,
        "tipc-discussion@lists.sourceforge.net" 
	<tipc-discussion@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes [was: TIPC 2.0 and
 TIPC_SUB_SERVICE]
Message-ID: <20101018184628.GX8781@llucax.com.ar>
References: <20100927163823.GD2834@integratech.com.ar>
 <29C1DC0826876849BDD9F1C67ABA2943090B67EC@ala-mail09.corp.ad.wrs.com>
 <20100929153805.GG2834@integratech.com.ar>
 <29C1DC0826876849BDD9F1C67ABA29430914AC18@ala-mail09.corp.ad.wrs.com>
 <20101001150034.GS8781@llucax.com.ar>
 <0434463FDA60A94FA978ACA44617682DEE843EDD79@EUSAACMS0702.eamcs.ericsson.se>
 <20101001162346.GV8781@llucax.com.ar>
 <4CA69F18.7000005@amln.net>
 <0434463FDA60A94FA978ACA44617682DEE8446A03B@EUSAACMS0702.eamcs.ericsson.se>
 <20101018150422.GV8781@llucax.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018150422.GV8781@llucax.com.ar>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leandro Lucarella, el 18 de octubre a las 12:04 me escribiste:
> This means D can't be used to write code that uses TIPC if you target
> kernels >= 2.6.35 (unless they write their own bindings, or at least use
> a custom TIPC_SUB_SERVICE constant). I could change the TIPC_SUB_SERVICE
> value, but then people using older kernels will be screwed. Another
> option is to use the version statement (kind of like C's #ifdef):
> 
> 	version (TIPC_2_0)
> 		const TIPC_SUB_SERVICE = 0x00;
> 	else
> 		const TIPC_SUB_SERVICE = 0x02;

I keep finding problems with this change. Another, no D-related, problem
with this change is old code could be silently (and very subtly) broken
if they check for TIPC_SUB_SERVICE as a flag with something like:

	if (s.filter & TIPC_SUB_SERVICE)
		/* do something */

Because TIPC_SUB_SERVICE has changed its semantics, not just its value,
and the new value (0x00) will give you always 0 in that test. This one
is really tricky, because the application code will fail silently, there
will be no dmesg indication of a failure, nor the connection to the
topology service be closed. You might get a compiler warning if you're
lucky.

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
Novocaine for the soul
you better give me something
to fill the hole
before I sputter out
