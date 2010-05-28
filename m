Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0E1Kzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:55:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63488 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab0E1Kzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pZdG1vR+kwDUF2pBNE713RaHeId68deqwXdnwFjvTwC8t6mLLa4xV5Ac565QFXlP+H
         M+4n9bRPZaPwsX6Ahxkoq4ZXr4ouBv6Mf7CsQWGhwKOk2qCsjo8oWKnsD4LRJudTgn49
         fafzZyXP3hf2PlABv/52nrteS898JWTwyVuIs=
MIME-Version: 1.0
In-Reply-To: <E1OHwZC-0002KS-EJ@pomaz-ex.szeredi.hu>
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu> <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com> 
	<E1OHwZC-0002KS-EJ@pomaz-ex.szeredi.hu>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 28 May 2010 18:55:23 +0800
Message-ID: <AANLkTikJMLiaUIVohTPy4DLF4XmWsy7LCx0bDheq2aHM@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: axboe@kernel.dk, viro@zeniv.linux.org.uk, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 6:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, 28 May 2010, Changli Gao wrote:
>> On Fri, May 28, 2010 at 5:42 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > On Wed, 26 May 2010, Changli Gao wrote:
>> >> fix updating sd->pos wrongly.
>> >>
>> >> In error path, we don't need to updating sd->pos, if the file isn't seekable.
>> >
>> > This patch is nonsense.  Why should we handle sd->pos != 0 case
>> > differently?
>> >
>>
>> If the in file isn't seekable, its splice_read won't update *ppos, so
>> in the error path, we'd better not change it too. Otherwise, some
>> assumption will go wrong.
>
> That may be true, but the patch is still nonsense.
>
> Look, your patch is updating/not updating sd->pos based on whether it
> is zero or not.  It will prevent updating the position for sockets,
> but it will also prevent updating the position for regular files if
> the position is zero, which is really not what we want.

I think you misread my patch. Before checking the sd->pos, sd->pos
already is updated with the value returned by splice_read(), so if in
file is seekabble, sd->pos is non-zero when I checking it.



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
