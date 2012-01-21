Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2AUHpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 02:45:15 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:25068 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372Ab2AUHpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 02:45:11 -0500
X-IronPort-AV: E=Sophos;i="4.71,547,1320620400"; 
   d="scan'208";a="140840610"
Date: Sat, 21 Jan 2012 08:45:08 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Brice Goglin <Brice.Goglin@inria.fr>
cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>, julia.lawall@lip6.fr,
        Michal Marek <mmarek@suse.cz>, mmarek@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccicheck: change handling of C={1,2} when M= is set
In-Reply-To: <4F1A6AC1.70300@inria.fr>
Message-ID: <alpine.DEB.2.02.1201210843550.1939@hadrien>
References: <4F1928FC.8090300@inria.fr> <1327101035-7684-1-git-send-email-Gregory.Dietsche@cuw.edu> <1327101035-7684-2-git-send-email-Gregory.Dietsche@cuw.edu> <4F1A6AC1.70300@inria.fr>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-596520168-1327131909=:1939"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-596520168-1327131909=:1939
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT



On Sat, 21 Jan 2012, Brice Goglin wrote:

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

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

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
>
>
--8323329-596520168-1327131909=:1939--
