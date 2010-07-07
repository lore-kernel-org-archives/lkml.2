Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0GGLEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:04:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0GGLEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:04:39 -0400
Message-ID: <4C345F44.4070800@suse.cz>
Date: Wed, 07 Jul 2010 13:04:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nicolas Palix <npalix@diku.dk>
Cc: Kulikov Vasiliy <segooon@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
       Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
       cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccicheck: use $KBUILD_EXTMOD when available
References: <1278170438-8136-1-git-send-email-segooon@gmail.com> <201007032149.30704.npalix@diku.dk>
In-Reply-To: <201007032149.30704.npalix@diku.dk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.7.2010 21:49, Nicolas Palix wrote:
> Hi,
> 
> On Saturday 03 July 2010 17:20:34 Kulikov Vasiliy wrote:
>> Use $KBUILD_EXTMOD instead of $srctree when the latter is not null
>> to use make M=somedir.
>>
>> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>> ---
>>  scripts/coccicheck |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/scripts/coccicheck b/scripts/coccicheck
>> index b8bcf1f..7d66a55 100755
>> --- a/scripts/coccicheck
>> +++ b/scripts/coccicheck
>> @@ -1,5 +1,11 @@
>>  #!/bin/sh
>>  
>> +if [ -n "$KBUILD_EXTMOD" ]; then
>> +	CHECK_DIR="$KBUILD_EXTMOD"
>> +else
>> +	CHECK_DIR="$srctree"
>> +fi
>> +
>>  SPATCH="`which ${SPATCH:=spatch}`"
>>  
>>  if [ "$C" = "1" -o "$C" = "2" ]; then
>> @@ -64,7 +70,7 @@ coccinelle () {
>>  	echo ' http://coccinelle.lip6.fr/'
>>  	echo ''
>>  
>> -	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
>> +	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $CHECK_DIR || exit 1
>>      else
>>  	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
>>      fi
>>
> 
> In doing so, the output of the patch mode will produce patches relative to $KBUILD_EXTMOD.
> I am not sure of what most of developers want but if the patches must be relative to
> the Linux kernel root, the following patch must be used.

If you are checking your out-of-tree module, then you're probably not
going to send the resulting patch to lkml.

Michal
