Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0E2OXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 10:23:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54220 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab0E2OXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 10:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YmUAY9RAkjvlJmWEYNMYgL4YX5d8P7EWfcXAIOxAJ0/N7o00A0cbRWJtLgbASnI9oV
         +1dhVJcU1ghzj43z57wEtzEgasN6RJSCjvUyRG/FlQW4tGCkVn+YPRY+Zw7G9QVhK7q0
         Gktock/KyhPmwGGYsWOEk76r0j3g/vdvogUXQ=
MIME-Version: 1.0
In-Reply-To: <20100529140901.GD3106@shareable.org>
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu> <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com> 
	<E1OHwZC-0002KS-EJ@pomaz-ex.szeredi.hu> <AANLkTikJMLiaUIVohTPy4DLF4XmWsy7LCx0bDheq2aHM@mail.gmail.com> 
	<20100529140901.GD3106@shareable.org>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 29 May 2010 22:22:54 +0800
Message-ID: <AANLkTikycDykLRPnRZFAbdIszTOMDVFoX4DGiLcCvSqd@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
To: Jamie Lokier <jamie@shareable.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, axboe@kernel.dk,
       viro@zeniv.linux.org.uk, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 10:09 PM, Jamie Lokier <jamie@shareable.org> wrote:
>
> Not true if the "file" is /dev/mem or /dev/kmem.  The starting offset
> can be negative, so can end at zero.
>
> It's an obscure case and I don't know if you can sendfile from
> /dev/{,k}mem anyway :-) but illustrates why sd->pos != 0 is dubious.
>

So the safe way is checking if splice_read() updates pos or not, isn't it?

if (sd->pos != prev_pos)
    sd->pos = prev_pos + ret;


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
