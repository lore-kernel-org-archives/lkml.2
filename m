Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1KUPyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:54:39 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:38845 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751517Ab1KUPyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:54:37 -0500
Message-ID: <4ECA73B2.2010003@xenotime.net>
Date: Mon, 21 Nov 2011 07:52:18 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] digsig: fix build errors
References: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>	<4EC9EBD2.3040708@xenotime.net> <CALLzPKYmmah9EcXgN2ruRLoFSjV-ozn1pBMans=n2_ouB8Tqsg@mail.gmail.com>
In-Reply-To: <CALLzPKYmmah9EcXgN2ruRLoFSjV-ozn1pBMans=n2_ouB8Tqsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 02:32 AM, Kasatkin, Dmitry wrote:
> On Mon, Nov 21, 2011 at 8:12 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix build errors by adding kconfig dependency on KEYS:
>>
>> lib/digsig.c:106:16: error: dereferencing pointer to incomplete type
>> lib/digsig.c:107:11: error: dereferencing pointer to incomplete type
>> lib/digsig.c:184:14: error: dereferencing pointer to incomplete type
>> lib/digsig.c:223:3: error: 'key_ref_t' undeclared (first use in this function)
>> lib/digsig.c:223:13: error: expected ';' before 'kref'
>> lib/digsig.c:224:3: error: 'kref' undeclared (first use in this function)
>> lib/digsig.c:224:3: error: implicit declaration of function 'keyring_search'
>> lib/digsig.c:231:3: error: implicit declaration of function 'request_key'
>>
>> and after changing lib/Kconfig:
>> warning: (INTEGRITY_DIGSIG) selects DIGSIG which has unmet direct dependencies (CRYPTO && KEYS)
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>> ---
>>  lib/Kconfig                |    4 ++--
>>  security/integrity/Kconfig |    2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> --- next-2011-1121.orig/lib/Kconfig
>> +++ next-2011-1121/lib/Kconfig
>> @@ -294,10 +294,10 @@ config MPILIB_EXTRA
>>
>>  config DIGSIG
>>        tristate "In-kernel signature checker"
>> -       depends on CRYPTO
>> +       depends on CRYPTO && KEYS
> 
> this patch was in /crypto dir before, now it is in /lib...
> I think CRYPTO is not needed at all at the moment..
> 
> 
>>        select MPILIB
>>        help
>>          Digital signature verification. Currently only RSA is supported.
>> -         Implementation is done using GnuPG MPI library
>> +         Implementation is done using GnuPG MPI library.
>>
>>  endmenu
>> --- next-2011-1121.orig/security/integrity/Kconfig
>> +++ next-2011-1121/security/integrity/Kconfig
>> @@ -5,7 +5,7 @@ config INTEGRITY
>>
>>  config INTEGRITY_DIGSIG
>>        boolean "Digital signature verification using multiple keyrings"
>> -       depends on INTEGRITY
>> +       depends on INTEGRITY && CRYPTO && KEYS
> 
> Is it really needed, because 2 lines bellow is "select DIGSIG", which
> will depend on KEYS??

Feel free to fix the build errors any way that you want to do it,
but please get them fixed.  Don't leave it as is.

> 
>>        default n
>>        select DIGSIG
>>        help
>>
> 
> Thanks!


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
