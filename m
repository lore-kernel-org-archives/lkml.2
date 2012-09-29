Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab2I2Ab4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:31:56 -0400
Received: from nm19.bullet.mail.sp2.yahoo.com ([98.139.91.89]:47893 "EHLO
	nm19.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758352Ab2I2Aby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:31:54 -0400
X-Yahoo-Newman-Id: 588881.40707.bm@omp1017.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HsECRrEVM1kP1hmvObDilLJrsdmKkSEAOTnF0AemoZnpyWZ
 gC2J82qoh8EIu4aqDs1LlYkPs19MQ6RjdBBsp367Gj2LDf4NpFQK4hfIIdgB
 ._DQms8IZH4JcXz6.VxWmY7OHMNC82FfPqCA1nGBF1gHkSrsgR.rWAbxdeKL
 uGJffrNWWwepTC_dui0QEgXgBXMsKyjjZnSjrPWKIj673n5po4vQCFD3CUCT
 CakN7nvCKsjJTH9zG9Yf_bLnFZVBCI.KJ_1ppkLtpbxIaFRrzE34ZbVz.hdf
 PTqMv9YeSzs6TfLh01IJT6CU4X7i2nwLqz4rsM_OkCJAhRkFUEDp2rU4dMUu
 Qt1_YnXmtqIk8jjmZS6QBpkuuJLO9IOVQ0HcimK1eug5vhUyuNlSUkmz1YES
 KdVpIiEaBiDurH4BC0238wVM_JU4jHhpJXk0iveayb.iXtyQygw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50664179.5090608@att.net>
Date: Fri, 28 Sep 2012 19:31:53 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Bulk] Re: [PATCH 4/10] compiler-gcc{3,4}.h: Use GCC_VERSION
 macro
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-5-git-send-email-daniel.santos@pobox.com> <20120929002029.GA13907@jtriplet-mobl1>
In-Reply-To: <20120929002029.GA13907@jtriplet-mobl1>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 07:20 PM, Josh Triplett wrote:
> On Fri, Sep 28, 2012 at 06:20:05PM -0500, Daniel Santos wrote:
>> --- a/include/linux/compiler-gcc4.h
>> +++ b/include/linux/compiler-gcc4.h
>> @@ -13,11 +13,11 @@
>>  #define __must_check 		__attribute__((warn_unused_result))
>>  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
>>  
>> -#if __GNUC_MINOR__ > 0
>> +#if GCC_VERSION >= 40102
>>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
>>  #endif
> You've changed the semantics of this one; if literally translated, this
> should have become #if GCC_VERSION >= 40100.  If you intended to change
> that, could you please document why?  And in any case, could you make
> that semantic change in a separate commit from the switch to
> GCC_VERSION?
hmm, it looks like somebody commented out the #error that would normally
prevent that test from ever occurring on 4.1.0 or 4.1.1.
When I had written this patch, it wasn't commented out and I had assumed
that it was obvious from the context.
>  /* GCC 4.1.[01] miscompiles __weak */
>  #ifdef __KERNEL__
> -# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
> +# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
>  //#  error Your version of gcc miscompiles the __weak directive
>  # endif
>  #endif
> @@ -13,11 +13,11 @@
>  #define __must_check 		__attribute__((warn_unused_result))
>  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
>  
> -#if __GNUC_MINOR__ > 0
> +#if GCC_VERSION >= 40102
>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
>  #endif
I would say that commenting this out is bad if __weak is miscompiled. 
If we don't want to break the build, should we at least be defining
__weak to something else?

Daniel
