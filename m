Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2JAVBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:01:41 -0400
Received: from nm25-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.156]:30754 "HELO
	nm25-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754545Ab2JAUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:41:13 -0400
X-Yahoo-Newman-Id: 348824.65127.bm@smtp106.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ROEcG_QVM1kK50o9f7iTYXGjkRqLeV9OWNZkl0PkCFl0sI9
 7Y.2tThh379oIAD7QkWLDwI59UO7Ff091g8pPJ73c3PE6FTppC34BZqJqf34
 TWdUFhKXXM.afyJqLsRZkHGWGetChhFYyWxgcziLTZKH3U80zxNVz2nUwEfK
 EUJ0O.Stfb3A0ld_u0QTOWiSDdIZKYjoigcrgkZGSbssylY5nLIRnhYywUho
 miO30yIBHQry7wQIR7VDZjfNBmPRjBzGpgDFEmjiDf9HRvc5m2nBDUFPgeWf
 4eNuXteYlto_Vfn78Gb.xP.z7ECZ93HdDi9gG6xt8bbWtUSIy6GICntjoM0n
 kW_8TsAx3MmAfEtS94htePwi_T.Myl7u57LVaovbMAuispu5FABZ59agsvqw
 CxX1g2SR5O0nryVkqHIIX0WKXiBTx9QtR_tXUlvFdp44FAOgvdQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5069FFEA.20900@att.net>
Date: Mon, 01 Oct 2012 15:41:14 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 0/25] Generic Red-Black Trees
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com> <20121001124331.540a2615.akpm@linux-foundation.org>
In-Reply-To: <20121001124331.540a2615.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I'm really sorry for the debacle of this round of patches.  It turns out
that my patches weren't reaching LKML because my recipient list was too
large
and the server was tagging it as spam, so none of these patches you
committed
ever made it to LKML. :(  To fix that, I broke the 25 patches
into 3 smaller sets.

[PATCH 0/10] Cleanup & new features for compiler*.h and bug.h
[PATCH 0/3] kernel-doc bug fixes
[PATCH v6 0/10] Generic Red-Black Trees

On 10/01/2012 02:43 PM, Andrew Morton wrote:
> On Thu, 27 Sep 2012 20:54:16 -0500
> Daniel Santos <daniel.santos@pobox.com> wrote:
>
>> This patch set improves on Andrea Arcangeli's original Red-Black Tree
>> implementation by adding generic search and insert functions with
>> complete support for:
>
> I grabbed patches 1-7, but I don't expect to send them in for 3.7. 
> It's not a good time to be merging new material, but I like cleanups.
>
I probably should have bumped the version to 7 to reduce the confusion.
Some maintainers have requested some changes in some of the first 10
patches (the compiler*.h & bug.h).  Can you roll them back or is it
better to
just send the corrections?

So one change, which you noted ("[PATCH v6 4/25] compiler-gcc{3,4}.h: Use
GCC_VERSION macro" is now "[PATCH 4/10]..." of the "Cleanup & new
features for
compiler*.h and bug.h" patch set.

>>  /* GCC 4.1.[01] miscompiles __weak */
>>  #ifdef __KERNEL__
>> -# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
>> +# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
>>  //#  error Your version of gcc miscompiles the __weak directive
>>  # endif
>>  #endif
>> @@ -13,11 +13,11 @@
>>  #define __must_check 		__attribute__((warn_unused_result))
>>  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
>>  
>> -#if __GNUC_MINOR__ > 0
>> +#if GCC_VERSION >= 40102
> Is this correct (and clear)?  I'd expect
>
> 	#if GCC_VERSION > 40000
This should actually be gcc 4.1.0 or higher. I was going from the
presumption
that 4.1.0 & 4.1.1 wouldn't compile due to the __weak thing above, but
that's
unrelated (and now commented out), so it should just be >= 4.1.0.

#if GCC_VERSION >= 40100

They also want the order of patches 5 & 6 reversed (breaks build in between
otherwise) and patch notes added to the patch "[PATCH 6/10] bug.h: Replace
__linktime_error with __compiletime_error" and we're going to rework
BUILD_BUG_ON.

I can rebase against whatever you like and send either corrections or an
updated patch set. Just tell me what works please.

Thank you for your patience as I learn the ropes in this project.

Daniel

