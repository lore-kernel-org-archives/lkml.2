Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750832Ab1JLEQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:16:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2694 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1JLEQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:16:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=hV8IenlTHw0HLDE8POu1auZ5n4W+1ZtfRBc4XAhfbSXwcjjjNpJzbqG6zgxMyxu5x
	B0XXacKaMMNaXo5YjHDxg==
MIME-Version: 1.0
In-Reply-To: <1318387734.3686.2.camel@edumazet-laptop>
References: <20111010145206.6f7e9ee2@nehalam.linuxnetplumber.net>
	<1318382887-31824-1-git-send-email-muralira@google.com>
	<1318387734.3686.2.camel@edumazet-laptop>
Date: Tue, 11 Oct 2011 21:16:44 -0700
Message-ID: <CAP3iWTQXHwzw-qUYVfT--uNv4pNZnu0ROJnF7B1VLeZBbrfdqw@mail.gmail.com>
Subject: Re: [PATCH v3] net-netlink: Add a new attribute to expose TOS values
 via netlink
From: MuraliRaja Muniraju <muralira@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,
     I think it would be useful to expose the values this way.
     I shall make the changes to add TCLASS for ipv6 in the description.

     Regarding the TIME_WAIT state, I think it would be better of not
exposing the values because there would hardly be anything to transmit
during this time.

Thanks,
Murali

On Tue, Oct 11, 2011 at 7:48 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 11 octobre 2011 à 18:28 -0700, Muraliraja Muniraju a écrit :
>> From: Murali Raja <muralira@google.com>
>>
>> This patch exposes the tos value for the TCP sockets when the TOS flag
>> is requested in the ext_flags for the inet_diag request. This would mainly be
>> used to expose TOS values for both for TCP and UDP sockets. Currently it is
>> supported for TCP. When netlink support for UDP would be added the support
>> to expose the TOS values would alse be done.
>>
>
> You could mention TCLASS support for IPv6
>
>> Signed-off-by: Murali Raja <muralira@google.com>
>> ---
>> Changelog since v2:
>> - Adding support for IPV6 class and using right API's
>> Changelog since v1:
>> - Removing reserved field
>>
>>  include/linux/inet_diag.h |    9 ++++++++-
>>  net/ipv4/inet_diag.c      |    5 +++++
>>  2 files changed, 13 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
>> index bc8c490..e36093d 100644
>> --- a/include/linux/inet_diag.h
>> +++ b/include/linux/inet_diag.h
>> @@ -97,9 +97,10 @@ enum {
>>       INET_DIAG_INFO,
>>       INET_DIAG_VEGASINFO,
>>       INET_DIAG_CONG,
>> +     INET_DIAG_TOS,
>>  };
>>
>> -#define INET_DIAG_MAX INET_DIAG_CONG
>> +#define INET_DIAG_MAX INET_DIAG_TOS
>>
>>
>>  /* INET_DIAG_MEM */
>> @@ -120,6 +121,12 @@ struct tcpvegas_info {
>>       __u32   tcpv_minrtt;
>>  };
>>
>> +/* INET_DIAG_TOS */
>> +
>> +struct inet_diag_tos {
>> +     __u8    idiag_tos;
>> +};
>
> Are you sure its still needed ?
>
> I am now wondering what is done in TIME_WAIT state.
>
>
>



-- 
Thanks,
Murali
