Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1JJV3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:29:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1JJV3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:29:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=q8gAHpCdveo4B0YGzUYrEfJ5n3m8qn0jIgp4lxerCIG0AEzTmob1FotWdnvI8hSy7
	gG1ClpJUY10HHvTiMKgAA==
MIME-Version: 1.0
In-Reply-To: <20111010140957.69f10b06@nehalam.linuxnetplumber.net>
References: <20111010130713.6df8bfe4@nehalam.linuxnetplumber.net>
	<1318278745-27734-1-git-send-email-muralira@google.com>
	<20111010140957.69f10b06@nehalam.linuxnetplumber.net>
Date: Mon, 10 Oct 2011 14:29:36 -0700
Message-ID: <CAP3iWTQ-7sNWMNazrmA1ZbNRATyd=MzKKsVtCHQ2_4dYboG=jg@mail.gmail.com>
Subject: Re: [PATCH v2] net-netlink: Add a new attribute to expose TOS values
 via netlink
From: MuraliRaja Muniraju <muralira@google.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "David S. Miller\"" <davem@davemloft.net>,
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

Stephen,
            Regarding the only field in the structure.

            -- I thought that adding it as a attribute and exposing it
via a extension instead of modifying the inet_diag_sockid structure.
This is to make sure that older binaries will not have issues with the
later kernel. Do you have any alternate suggestions.

            This change has been done keeping IPV4 in mind. I do not
see the V6 sockets exposed thought netlink. Please correct me if I am
reading it wrong.

Thanks,
Murali

On Mon, Oct 10, 2011 at 2:09 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Mon, 10 Oct 2011 13:32:25 -0700
> Muraliraja Muniraju <muralira@google.com> wrote:
>
>> From: Murali Raja <muralira@google.com>
>>
>> This patch exposes the tos value for the TCP sockets when the TOS flag
>> is requested in the ext_flags for the inet_diag request. This would mainly be
>> used to expose TOS values for both for TCP and UDP sockets. Currently it is
>> supported for TCP. When netlink support for UDP would be added the support
>> to expose the TOS values would alse be done.
>>
>> Signed-off-by: Murali Raja <muralira@google.com>
>> ---
>> Changelog since v1:
>> - Removing the reserved field.
>>
>>  include/linux/inet_diag.h |    9 ++++++++-
>>  net/ipv4/inet_diag.c      |    7 +++++++
>>  2 files changed, 15 insertions(+), 1 deletions(-)
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
> I think the idea is a good one, and useful, but want to make the
> ABI right.
> With only one entry, this doesn't need to be wrapped in a structure.
>
> Also does this work for IPv6 (Transport class) as well?
>
>



-- 
Thanks,
Murali
