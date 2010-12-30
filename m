Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab0L3F0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 00:26:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:41686 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0L3F0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 00:26:45 -0500
Message-ID: <4D1C180A.20000@suse.com>
Date: Thu, 30 Dec 2010 00:26:34 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, Dan Carpenter <error27@gmail.com>,
        balbir@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
References: <4D1BCE58.4000902@suse.com> <20101229161418.d34bf0d4.akpm@linux-foundation.org>
In-Reply-To: <20101229161418.d34bf0d4.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/29/2010 07:14 PM, Andrew Morton wrote:
> On Wed, 29 Dec 2010 19:12:08 -0500 Jeff Mahoney <jeffm@suse.com> wrote:
> 
>>  Commit 4be2c95d added a null field to align the taskstats structure but
>>  the discussion centered around ia64. The issue exists on other platforms
>>  with inefficient unaligned access and adding them piecemeal would be
>>  an unmaintainable mess.
>>
>>  This patch uses Dave Miller's suggestion of using a combination of
>>  CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to determine
>>  whether alignment is needed.
>>
>>  Note that this will cause breakage on those platforms with applications
>>  like iotop which had hard-coded offsets into the packet to access the
>>  taskstats structure.
> 
> That seems a very good reason to not apply the patch.
> 
> Tell us more, please...

I don't want to rehash the same discussion, but any argument that
applied to ia64 applies any other 64-bit arch other than powerpc and x86_64.

- -Jeff

>>  The message seen on systems without the alignment fixes looks like:
>>  kernel unaligned access to 0xe000023879dca9bc, ip=0xa000000100133d10
>>
>>  The addresses may vary but resolve to locations inside __delayacct_add_tsk.
>>
>> Reported-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  kernel/taskstats.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/kernel/taskstats.c
>> +++ b/kernel/taskstats.c
>> @@ -349,7 +349,7 @@ static int parse(struct nlattr *na, stru
>>  	return ret;
>>  }
>>  
>> -#ifdef CONFIG_IA64
>> +#if defined(CONFIG_64BIT) && !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>>  #define TASKSTATS_NEEDS_PADDING 1
>>  #endif
>>  


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0cGAoACgkQLPWxlyuTD7IdTwCfXZ0KfZ3N/zafSzGCSa4cHEbN
EU8AoI/JK/1nkv5xHw4XP79wZAGo4hqk
=jAGp
-----END PGP SIGNATURE-----
