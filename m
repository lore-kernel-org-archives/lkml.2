Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0DHFLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:11:15 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46511 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0DHFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i8ddEB8UJD/Ul8nqIMBgGaTwqQpOg+fi9Op8efZkgQJZciHz1S/G7pgh8/1BKh/pSx
         00quiaS0sJVtztlfzuzfvyMGWU98qxdrS1wWbVrpUsN74dHNFVqpp87BO3suik0rgYKw
         PoTDqwBnDpn828mkeneMnYrqeisJMIj2oZERU=
Subject: Re: [PATCH] increase pipe size/buffers/atomicity :D
From: Eric Dumazet <eric.dumazet@gmail.com>
To: brian <knotwurk@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <x2sb985fb501004071838z51a832dftdfaece15e5a0e154@mail.gmail.com>
References: <x2sb985fb501004071838z51a832dftdfaece15e5a0e154@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 07:11:07 +0200
Message-ID: <1270703467.8141.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 19:38 -0600, brian a écrit :
> (tested and working with 2.6.32.8 kernel, on a Athlon/686)
> 
> 
> --- include/linux/pipe_fs_i.h.orig      2010-04-06 22:56:51.000000000 -0500
> +++ include/linux/pipe_fs_i.h   2010-04-06 22:56:58.000000000 -0500
> @@ -3,7 +3,7 @@
> 
>  #define PIPEFS_MAGIC 0x50495045
> 
> -#define PIPE_BUFFERS (16)
> +#define PIPE_BUFFERS (32)

Doing such a thing puts high pressure on stack usage on some parts of
the kernel, and actually slow down some benches.



