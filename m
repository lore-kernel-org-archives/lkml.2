Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360Ab1ETCCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:02:00 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:50021 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935391Ab1ETCBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n8kbIo27ui8xlO6VnE1d1VG2whrqWUnqd7Fio4695PfnttyVPl+N8CyglbQlawVTXS
         S2ZDDcTKwUv6Hx047NYyHubZTK68cbqpj9LghR0LwsPEQMQENAGiVHUFkvTQtCag4hJ1
         WiHaO+m7FunXXTDtgHpZR1heC3vc9gNYCwSn0=
MIME-Version: 1.0
In-Reply-To: <BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
References: <1305619677.2850.11.camel@edumazet-laptop>
	<1305715384-81716-1-git-send-email-tsunanet@gmail.com>
	<20110518.152653.1486764697527722925.davem@davemloft.net>
	<BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
Date: Thu, 19 May 2011 19:01:53 -0700
Message-ID: <BANLkTinBm0C4ZVE=M98AtsF--y03p4Hafg@mail.gmail.com>
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: tsuna <tsunanet@gmail.com>
Cc: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, hkchu@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:40 PM, tsuna <tsunanet@gmail.com> wrote:
> On Wed, May 18, 2011 at 12:26 PM, David Miller <davem@davemloft.net> wrote:
>> If you read the ietf draft that reduces the initial RTO down to 1
>> second, it states that if we take a timeout during the initial
>> connection handshake then we have to revert the RTO back up to 3
>> seconds.
>>
>> This fallback logic conflicts with being able to only change the
>> initial RTO via sysctl, I think.  Because there are actually two
>> values at stake and they depend upon eachother, the initial RTO and
>> the value we fallback to on initial handshake retransmissions.
>>
>> So I'd rather get a patch that implements the 1 second initial
>> RTO with the 3 second fallback on SYN retransmit, than this patch.
>>
>> We already have too many knobs.
>
> I was hoping this knob would be accepted because this is such an
> important issue that it even warrants an IETF draft to attempt to
> change the standard.  I'm not sure how long it will take for this
> draft to be accepted and then implemented, so I thought adding this
> simple knob today would really help in the future.

As one of the co-authors of rfc2988bis I was planning to provide a patch
as soon as the draft gets approved but it looks like you have beaten
me to it :)

Personally I'm in favor of a knob too. We at Google has added such a
knob for years.

Jerry

>
> Plus, should the draft be accepted, this knob will still be just as
> useful (e.g. to revert back to today's behavior), and people might
> want to consider adding another knob for the fallback initRTO (this is
> debatable).  I don't believe this knob conflicts with the proposed
> change to the standard, it actually goes along with it pretty well and
> helps us prepare better for this upcoming change.
>
> I agree that there are too many knobs, and I hate feature creep too,
> but I've found many of these knobs to be really useful, and the degree
> to which Linux's TCP stack can be tuned is part of what makes it so
> versatile.
>
> --
> Benoit "tsuna" Sigoure
> Software Engineer @ www.StumbleUpon.com
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
