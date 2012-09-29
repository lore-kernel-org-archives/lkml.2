Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab2I2Anu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:43:50 -0400
Received: from nm36-vm7.bullet.mail.bf1.yahoo.com ([72.30.238.143]:43711 "HELO
	nm36-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758342Ab2I2Ant (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:43:49 -0400
X-Yahoo-Newman-Id: 739817.54290.bm@smtp113.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Oz0EiJsVM1nke..SXgOJwKFEfyEpAQtognygVzgoz5UVy9O
 nX8WS.csl2Gl_SGs2ttVHWMyMxUBAI_8hQ3pYe30OFim8LBhi9.m0N6HHO5J
 TfJ0kwxPRF8QwndkEM3JuaNo_phWpNhR6Weusv2ZTKh0l8IYdDJhTSOOxaEf
 d49KApGDO7GfM6AzWz4uewmIez7zV2hQ3.wSEwBdKjwBoYN7gkU3XGHOAygz
 a_bx.pIWKwTS07EkdsgwT7YND5bGI3JAT5udaGNTHqHALE.16Y0tEWKi2Nmg
 ucB9uTdTaNxqLujbIvn9Ker3n0Imqzxi44RUQwc.Nm1Ljc3_RVy9gWNZLM9T
 .nu1h26QRf1gVsWPZiSpS66jVXfn3Bi9PgmMBhzLXqJGi_XkVnBBgR5B3jnD
 lGY5vA9w_NV3Cmp9gVg4cnE8MH1zRGD4Zoao.WFLoF0lxRlkQ9g--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50664308.6020601@att.net>
Date: Fri, 28 Sep 2012 19:38:32 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
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
Subject: Re: [PATCH 7/10] compiler{,-gcc4}.h: Introduce __flatten function
 attribute
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-8-git-send-email-daniel.santos@pobox.com> <20120929002626.GD13907@jtriplet-mobl1>
In-Reply-To: <20120929002626.GD13907@jtriplet-mobl1>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 07:26 PM, Josh Triplett wrote:
> On Fri, Sep 28, 2012 at 06:20:08PM -0500, Daniel Santos wrote:
>> --- a/include/linux/compiler-gcc4.h
>> +++ b/include/linux/compiler-gcc4.h
>> @@ -15,7 +15,12 @@
>>  
>>  #if GCC_VERSION >= 40102
>>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
>> -#endif
>> +
>> +/* flatten introduced in 4.1, but broken in 4.6.0 (gcc bug #48731)*/
>> +# if GCC_VERSION != 40600
>> +#  define __flatten __attribute__((flatten))
>> +# endif
>> +#endif /* GCC_VERSION >= 40102 */
> Same comment as before: why 40102 rather than 40100?
Again, I'm presuming building with 4.1.0 or 4.1.1 will always have the
build broken earlier.  I don't have any objections to changing this, but
it would seem that the issue with the __weak attribute needs to be resolved.

Daniel
