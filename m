Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1JLTA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:00:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1JLTA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:00:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:content-transfer-encoding;
	b=Y5tBL1pod1MKXjjEgiVhEEHf4htwSqLj+idIGH518HRRS22ieRzv/oduL2w2i5Mm6
	QPuZNfd4o1lTMtKgp3DHw==
MIME-Version: 1.0
In-Reply-To: <1318393869.3686.26.camel@edumazet-laptop>
References: <20111010145206.6f7e9ee2@nehalam.linuxnetplumber.net>
	<1318382887-31824-1-git-send-email-muralira@google.com>
	<1318387734.3686.2.camel@edumazet-laptop>
	<CAP3iWTQXHwzw-qUYVfT--uNv4pNZnu0ROJnF7B1VLeZBbrfdqw@mail.gmail.com>
	<1318393869.3686.26.camel@edumazet-laptop>
Date: Wed, 12 Oct 2011 12:00:23 -0700
Message-ID: <CAP3iWTSkPinSDbi761EsUQ_ZX54e=yGioC7=c7qHRd+17-_xqw@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,
     I am planning to not add code for the TIME_WAIT case as the tos
values are zero as they are not saved. Please let me if this is OK.
Thanks,
Murali

On Tue, Oct 11, 2011 at 9:31 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 11 octobre 2011 à 21:16 -0700, MuraliRaja Muniraju a écrit :
>> Eric,
>>      I think it would be useful to expose the values this way.
>>      I shall make the changes to add TCLASS for ipv6 in the description.
>>
>>      Regarding the TIME_WAIT state, I think it would be better of not
>> exposing the values because there would hardly be anything to transmit
>> during this time.
>>
>
> My remark had nothing to do with your patch actually :
>
> We dont store TOS/TCLASS on TIME_WAIT sockets, so you cannot report
> value in inet_diag.
>
> But we do send packets on behalf of TIME_WAIT sockets ;)
>
> Think about ACK messages. They probably are sent with a 0 TOS/TCLASS
> field... I am not sure its a problem or not.
>
>
>
>



-- 
Thanks,
Murali
