Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2BVPgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:36:42 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18121
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab2BVPgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:36:41 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Feb 2012 10:36:40 EST
X-IronPort-AV: E=Sophos;i="4.73,464,1325458800"; 
   d="scan'208";a="132460031"
Message-ID: <4F45093B.3030802@inria.fr>
Date: Wed, 22 Feb 2012 16:26:51 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
CC: julia.lawall@lip6.fr, mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccicheck: change handling of C={1,2} when M= is set
References: <4F1928FC.8090300@inria.fr> <1327101035-7684-1-git-send-email-Gregory.Dietsche@cuw.edu> <1327101035-7684-2-git-send-email-Gregory.Dietsche@cuw.edu> <4F1A6AC1.70300@inria.fr>
In-Reply-To: <4F1A6AC1.70300@inria.fr>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless I missed something, this fix still has not been applied in 3.3-rc.
Brice



Le 21/01/2012 08:35, Brice Goglin a écrit :
> Thanks a lot Greg, make C=2 CHECK=script/coccicheck M=... is back.
>
> Tested-by: Brice Goglin <Brice.Goglin@inria.fr>
>
>
>
> Le 21/01/2012 00:10, Greg Dietsche a écrit :
>> This patch reverts a portion of d0bc1fb4 so that coccicheck will
>> work properly when C=1 or C=2.
>>
>> Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
>> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
>> ---
>>  scripts/coccicheck |   13 ++++---------
>>  1 files changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/scripts/coccicheck b/scripts/coccicheck
>> index 3c27764..823e972 100755
>> --- a/scripts/coccicheck
>> +++ b/scripts/coccicheck
>> @@ -9,15 +9,10 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
>>  #    FLAGS="-ignore_unknown_options -very_quiet"
>>  #    OPTIONS=$*
>>  
>> -    if [ "$KBUILD_EXTMOD" = "" ] ; then
>> -        # Workaround for Coccinelle < 0.2.3
>> -        FLAGS="-I $srctree/include -very_quiet"
>> -        shift $(( $# - 1 ))
>> -        OPTIONS=$1
>> -    else
>> -	echo M= is not currently supported when C=1 or C=2
>> -	exit 1
>> -    fi
>> +# Workaround for Coccinelle < 0.2.3
>> +	FLAGS="-I $srctree/include -very_quiet"
>> +	shift $(( $# - 1 ))
>> +	OPTIONS=$1
>>  else
>>      ONLINE=0
>>      FLAGS="-very_quiet"

