Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2JGS2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:28:09 -0400
Received: from nm6.bullet.mail.ne1.yahoo.com ([98.138.90.69]:45216 "HELO
	nm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753545Ab2JGS16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:27:58 -0400
X-Yahoo-Newman-Id: 618179.30800.bm@omp1007.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tTEgd38VM1mvF81jP4IHbep7THcKkfqcui3238eEX1jj5wq
 oOiykpKEYvAOVMLUH1hvTPy6u.rT1u022YkXMzlgzxOBU0f0qCHFYtU4q6XE
 TPOsDQw5JqYQcNEpMBNfDq17UeXhfAUY4VafGN.6tjy63SUsQKxvLQX3gfdD
 qrbR1cfzSDeyHaZFfVtYGr9NRU_IIzA9_Dz2gTjvgHr7Ud0ec9UjgcGqcrma
 Xb1jViAwi43z_SIshwqZQQdAxzYeSKHPPTIqnJWE0q4aL.HDby7QQxKCkuBm
 aJuKDdkPZM82q2lGQu60o2EqT6aZuySkqOVuuQaTdLsIjDp6zMtWRiuLc4co
 kOHEJlbG3onkT2aCsEAjXglBsRSjSibCkjQ8JyKXMSrF4dIURRg0MTiiG77v
 x4O65F5S52_Fklj_mu6uQoAl7wcPzUG6f1Heh0p5Bbgfcr0MrGlE-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5071C9AE.2010106@att.net>
Date: Sun, 07 Oct 2012 13:27:58 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v2 03/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com> <1349466169-20637-3-git-send-email-daniel.santos@pobox.com> <20121006231041.GB3278@liondog.tnic>
In-Reply-To: <20121006231041.GB3278@liondog.tnic>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 06:10 PM, Borislav Petkov wrote:
> On Fri, Oct 05, 2012 at 02:42:42PM -0500, danielfsantos@att.net wrote:
>> Using GCC_VERSION reduces complexity, is easier to read and is GCC's
>> recommended mechanism for doing version checks. (Just don't ask me why
>> they didn't define it in the first place.)  This also makes it easy to
>> merge compiler-gcc{,3,4}.h should somebody want to.
>>
>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
>> Acked-by: David Rientjes <rientjes@google.com>
>> ---
>
> [ … ]
>
>> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
>> index 4506d65..bbfeb13 100644
>> --- a/include/linux/compiler-gcc4.h
>> +++ b/include/linux/compiler-gcc4.h
>> @@ -4,7 +4,7 @@
>>  
>>  /* GCC 4.1.[01] miscompiles __weak */
>>  #ifdef __KERNEL__
>> -# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
>> +# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
>>  //#  error Your version of gcc miscompiles the __weak directive
>
> Did I miss something again? This "error" preprocessor function is
> commented out here? Why?
We'll have to ask Andrew.  Maybe so he can test on those versions of gcc?

commit d3ffe64a1dbcfe18b57f90f7c01c40c93d0a8b92
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Fri Sep 28 00:02:42 2012 +0000

    a
   
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 934bc34..997fd8a 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -5,7 +5,7 @@
 /* GCC 4.1.[01] miscompiles __weak */
 #ifdef __KERNEL__
 # if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
-#  error Your version of gcc miscompiles the __weak directive
+//#  error Your version of gcc miscompiles the __weak directive
 # endif
 #endif


I can provide you a version of these patches rebased against Linus if
you like, which I am using to test since the -mm & -next trees aren't
working on my machine (hardware, .config and/or LVM/RAID setup). I
haven't put Walken's patches underneath them however.


