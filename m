Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1AWWTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 17:19:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52108 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1AWWTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 17:19:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VRSDdMPaMWkvxSelyFTGBc0ZuB0PsS0lXlwMlnVu10aYQDxKYkHJQrrAc7rQaG9Npk
         Opk6sAf/mAvNNR6FuO6nByI0dgfLfiPJWjY6Vq1AGOY5QvhRDCj0JtZ+TPWC8FNFRp5x
         TF4XOlSX5YvT5ZrmSW8GgQYq/d+Whwk7Gu6Z0=
MIME-Version: 1.0
In-Reply-To: <20110119182142.GA3620@elliptictech.com>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
	<1295385422-3592-5-git-send-email-arnd@arndb.de>
	<20110119154419.GA21411@elliptictech.com>
	<201101191717.58277.arnd@arndb.de>
	<20110119182142.GA3620@elliptictech.com>
Date: Mon, 24 Jan 2011 09:19:16 +1100
Message-ID: <AANLkTikutemVX0X3+Ftztj2P0TxboK3KvmhRbyx48r=K@mail.gmail.com>
Subject: Re: [PATCH 4/4] BKL: move CONFIG_BKL to staging
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most the x.25 BKLs have patches accepted over the past few months.
There are 3 remaining in send, receive and destroy that I haven't had
time to work through. If anyone wants to take a look at them I can
help test, but I wont have time until march to focus on them myself.

Andrew

On Thu, Jan 20, 2011 at 5:21 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2011-01-19 17:17 +0100, Arnd Bergmann wrote:
>> On Wednesday 19 January 2011, Nick Bowler wrote:
>> > I think this patch is not very nice.  It will cause working kernel
>> > configurations to turn into broken kernel configurations when the user
>> > does 'make oldconfig', with no warning.
>> >
>> > These drivers that use the BKL work fine.  Removing working features
>> > with no adequate replacement available seems like a serious regression
>> > to me.
>>
>> I wouldn't call it a serious regression since the code is still there
>> and both the symptom and the solution are rather obvious.
>
> Well, the code wouldn't still be there if they're removed in 2.6.39 as
> stated in your patch description.  While it may be obvious to people
> like you and me who know what the BKL is, I don't it's obvious to
> everyone that the cause of "my system doesn't boot anymore" is "oh,
> someone moved a dependency of a driver I've been using without issue for
> the past 5 years to staging!"
>
>> What's more important is to make any people still relying on the code
>> aware that it's going away unless someone fixes it, so they have the
>> chance to send patches or pay someone to fix it for them.
>
> Shouldn't the onus for fixing *working* drivers (or encouraging others
> to fix them) lie with the person(s) who are so keen to kill off features
> that they use?
>
> Surely we don't need to break oldconfig just to raise awareness that
> these drivers use deprecated features?
>
>> The remaining drivers that are still relying on the BKL are very
>> rarely used and for the less obscure ones (ufs, ipx and x.25), people
>> have volunteered to fix them (though I have seen no proper patches
>> for these yet).
>>
>> For the rest, I suppose if nobody complains, they can actually go
>> away, according to the logic that if nobody is using them, they most
>> likely are broken anyway and more a security risk than they are worth.
>
> Notwithstanding any of the above, one release cycle hardly seems like
> enough time to infer from "nobody complained" that "not a single person
> uses this driver."  Surely people concerned with security issues in code
> that they don't use can just... not enable it?  Nobody's forcing anyone
> to use these drivers.
>
> Neither the BKL nor any of these drivers are even mentioned in the
> feature removal schedule yet.
>
> --
> Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
