Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0DWKoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:44:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37344 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab0DWKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Uh6sxj9fxtg+WSWG5TxsqNHC77GWV+7LqE0h1a7QtiJ5UU8C+J/jnFGb7/J1p/bfqc
         nGLr2UyWPXtx5hx398/Rn+Y9llRL6qF2743JtpOOQKFqou0KtdIFyV631CAMQOKKlq/T
         9vt2dMDW1tdAs4B3yQQlaoBB5Ip/S32tWFLrU=
MIME-Version: 1.0
In-Reply-To: <20100423113717.1188415d@lxorguk.ukuu.org.uk>
References: <20100423112222.67cfcbb2@lxorguk.ukuu.org.uk>
	 <s2l21d7e9971004230324me3de75b0w58a9907999b7872a@mail.gmail.com>
	 <20100423113717.1188415d@lxorguk.ukuu.org.uk>
Date: Fri, 23 Apr 2010 20:44:38 +1000
Message-ID: <u2l21d7e9971004230344u491d3d6bqd093884ce8b21e7c@mail.gmail.com>
Subject: Re: Locking question for DRM
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 8:37 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > and I can't see what makes this safe if the drm_release for the master
>> > and a client occur at the same time ?
>>
>> lock_kernel in drm_release. We probably need to clean that up.
>
> I don't think that works. drm_open_helper doesn't appear to be under the
> BKL merely the struct mutex.

It blocks the case you specified of two releases happening together.

>
>> > The setmaster/dropmaster ioctl seems similar - the various conditional
>> > checks are not protected from parallel changes occuring during their
>> > execution.
>> >
>> > Is this a bug or is something clever afoot ?
>>
>> These ioctls are also under the BKL.
>
> But setmaster can sleep so the BKL is dropped on contention of the
> struct_mutex, ditto dropmaster

they should only sleep in the mutex lock nuless the driver callback is
allocating memory. but yeah its a bit of a mess.

Dave.
