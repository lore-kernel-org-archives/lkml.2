Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1CKBBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:01:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64448 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1CKBBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Opqsbj0iRy7+so2HhIdsmaTvkD8hPohVcflgBI8e17m0c5bGio6c6SXny6XF/OVzdO
         wgh/oEBgDV0gBooQKVqNYBs/Tf44lgUdH8/IIwWW7dnnKzdMcDYjKu8B4WmTPt7Wxag7
         AdzKMOPIwvoIhhDd/M4A/FbuQB6esKY7/EJBo=
MIME-Version: 1.0
In-Reply-To: <20110310164100.5af81e3b.akpm@linux-foundation.org>
References: <20110216200734.GA25184@merkur.ravnborg.org> <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110310164100.5af81e3b.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 10 Mar 2011 20:00:54 -0500
Message-ID: <AANLkTik7HwLs8Ux=THRy_-ByH4adebHodSLeEgSSqcsH@mail.gmail.com>
Subject: Re: [PATCH] kbuild: reenable section mismatch analysis
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/10 Andrew Morton :
> On Fri, 18 Feb 2011 21:47:20 +0100 Uwe Kleine-K__nig wrote:
>> This was disabled in commit
>>
>>       e5f95c8 (kbuild: print only total number of section mismatces found)
>>
>> because there were too many warnings.  Now we're down to a reasonable
>> number again, so we start scaring people with the details.
>>
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -102,11 +102,7 @@ config HEADERS_CHECK
>>
>>  config DEBUG_SECTION_MISMATCH
>>       bool "Enable full Section mismatch analysis"
>> -     depends on UNDEFINED || (BLACKFIN)
>>       default y
>> -     # This option is on purpose disabled for now.
>> -     # It will be enabled when we are down to a reasonable number
>> -     # of section mismatch warnings (< 10 for an allyesconfig build)
>>       help
>>         The section mismatch analysis checks if there are illegal
>>         references from one section to another section.
>
> eaaaargh!  650 lines of crap added to my i386 allmodconfig build output.

and it's going to keep staying all f-ed up until people start seeing
this stuff themselves when they write the bad code
-mike
