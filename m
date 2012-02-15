Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab2BOOHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:07:19 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab2BOOHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:07:17 -0500
Message-ID: <4F3BBC11.1030308@nod.at>
Date: Wed, 15 Feb 2012 15:07:13 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jengelh@medozas.de, rostedt@goodmis.org,
        pablo@netfilter.org, basti@b-bl.de
Subject: Re: [PATCH 2/2] Netfilter: xt_LOG: Add timestamp support
References: <1329314115-6899-1-git-send-email-richard@nod.at>  <1329314115-6899-2-git-send-email-richard@nod.at> <1329314492.2437.32.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1329314492.2437.32.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.02.2012 15:01, Eric Dumazet wrote:
> Le mercredi 15 février 2012 à 14:55 +0100, Richard Weinberger a écrit :
>> Using XT_LOG_ADD_TIMESTAMP it is possible to have a timestamp
>> directly in the log message.
>>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> ---
>>   include/linux/netfilter/xt_LOG.h |    1 +
>>   net/netfilter/xt_LOG.c           |    9 +++++++++
>>   2 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
>> index e4b1177..d84710c 100644
>> --- a/include/linux/netfilter/xt_LOG.h
>> +++ b/include/linux/netfilter/xt_LOG.h
>> @@ -8,6 +8,7 @@
>>   #define XT_LOG_UID		0x08	/* Log UID owning local socket */
>>   #define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
>>   #define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
>> +#define XT_LOG_ADD_TIMESTAMP	0x40	/* Add a timestamp */
>>   #define XT_LOG_MASK		0x6f
>>
>>   struct xt_log_info {
>> diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
>> index 211d341..2af2621 100644
>> --- a/net/netfilter/xt_LOG.c
>> +++ b/net/netfilter/xt_LOG.c
>> @@ -490,6 +490,15 @@ log_packet_common(struct sbuff *m,
>>   	if (loginfo->type == NF_LOG_TYPE_LOG)
>>   		sb_add(m, "<%d>", loginfo->u.log.level);
>>
>> +	if (loginfo->u.log.logflags&  XT_LOG_ADD_TIMESTAMP) {
>> +		struct timespec tv;
>> +		unsigned int msec;
>> +
>> +		getnstimeofday(&tv);
>> +		msec = tv.tv_nsec / NSEC_PER_MSEC;
>> +		sb_add(m, "TIMESTAMP=%li.%03li ", tv.tv_sec, msec);
>
> Since you want to use this temp variable "unsigned int msec" (I have no
> idea why...), you must change printf format accordingly : %03u instead
> of %03li

*grml*.
I'll remove the temp variable and use %03u.
The temp variable is a left over from another (not submitted) timestamp
implementation.

Thanks for spotting this!
//richard
