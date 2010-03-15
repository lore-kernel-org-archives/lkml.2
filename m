Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937196Ab0COXcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:32:08 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:48429 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937174Ab0COXcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FbrIYCP2cpoZkSd0orJ5VIYfFsUSOeyt3YFsyVhcskWhDSWpk3mwKxTpKkTC+JhtzA
         CJUwnbjZzExMv9g0WUDZCvu8vudScMPDkVhRZzsIEOw7rh8Q3RxztAv/hil9ICkFVKco
         XRxxM8ETVtpjbDyJfaEdiU8cpCkz0cqIzJbTk=
Message-ID: <4B9EC36F.8010404@gmail.com>
Date: Mon, 15 Mar 2010 17:31:59 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mike Hayward <hayward@loup.net>
CC: linux-kernel@vger.kernel.org, mvds.00@gmail.com
Subject: Re: SCSI GENERIC command queueing for block storage is unstable.
References: <201003151825.o2FIPUTV006948@alien.loup.net>
In-Reply-To: <201003151825.o2FIPUTV006948@alien.loup.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 12:25 PM, Mike Hayward wrote:
> After discovering that O_NONBLOCK reads and writes were actually
> blocking calls, I attempted to use the SCSI generic driver for
> nonblocking io.  The good news is that it is nonblocking; the bad news
> is that it is not dependable in any of the systems I have tested with.
>
> Does anyone know if these defects have been fixed in later kernels?
>
> 1. When queueing, write can occassionally return errno 12 (ENOMEM, Cannot
>     allocate memory).  This is documented in the SCSI GENERIC HOWTO,
>     however only for indirect io and it says extremely rare.  I can cause
>     it easily within a few hours and it can return even for direct io when
>     no io's are queued and 80% of the ram is free or in buffer cache.  The
>     fd polls as available for writing, but retrying never clears the error
>     and the fd is no longer usable.  This is a complete show stopper.
>
>     Linux 2.6.22.1-32.fc6 #1 SMP Wed Aug 1 14:30:16 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux

First off, have you tested any of these problems against a newer kernel?
