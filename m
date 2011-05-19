Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab1ESSMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:12:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64908 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934129Ab1ESSMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lRa00uWpO6B2FUIDJktMxajwiWOQJ/QJWZk27aQVwuWM5YuAy2SrHwpVEamN353t69
         BD7fCDRT7ZicUjbjLgCKTTkr1D2lkX4ZhBheEpYThsxGrOiNssxz/zbWywC5aEVYWY35
         B7pJXsufbzTAF1MkF89EFOj54thZbR6rsSFq4=
MIME-Version: 1.0
In-Reply-To: <20110519180559.722522150@clark.kroah.org>
References: <20110519180626.GA16555@kroah.com>
	<20110519180559.722522150@clark.kroah.org>
Date: Thu, 19 May 2011 20:12:44 +0200
X-Google-Sender-Auth: funNAzcr7yCQS2euOz9d51FrVYI
Message-ID: <BANLkTi=dKXo=TeTU7a--r3YCxrptNU3VVg@mail.gmail.com>
Subject: Re: [57/71] block: rescan partitions on invalidated devices on
 -ENOMEDIA too
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Thu, May 19, 2011 at 8:05 PM, Greg KH <gregkh@suse.de> wrote:
>
> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Tejun Heo <tj@kernel.org>
>
> commit 02e352287a40bd456eb78df705bf888bc3161d3f upstream.
>
> __blkdev_get() doesn't rescan partitions if disk->fops->open() fails,
> which leads to ghost partition devices lingering after medimum removal
> is known to both the kernel and userland.  The behavior also creates a
> subtle inconsistency where O_NONBLOCK open, which doesn't fail even if
> there's no medium, clears the ghots partitions, which is exploited to
> work around the problem from userland.
>
> Fix it by updating __blkdev_get() to issue partition rescan after
> -ENOMEDIA too.
>
> This was reported in the following bz.
>
>  https://bugzilla.kernel.org/show_bug.cgi?id=13029
>
> Stable: 2.6.38
>

Can you please hold this for a while?  It causes an extra warning
message to be printed during device detection.  It isn't harmful but
still.  I'll soon send a patch to resolve the issue and it would be
better for them to go together.

Thank you.

--
tejun
