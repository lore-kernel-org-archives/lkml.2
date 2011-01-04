Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1ADHPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:15:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41780 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1ADHPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:15:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ef9PoH8QjQqOCWqLyiJw/6UnJ7szrYuJctWWQ0gWNqSPqiaGYd+K6TUs5tRMAy3vhe
         QZz67r4k3fFz2no2sWSeh9PmzfvbJqqQGeKnXgqDBF9pBPgBGYJKdGNQVW75QLxK855N
         UARsquIaXd6VBNeGVQUh+qjWoNk2zjPn3hXY0=
MIME-Version: 1.0
In-Reply-To: <20110104061821.GA25886@gherkin.frus.com>
References: <20110104061821.GA25886@gherkin.frus.com>
Date: Tue, 4 Jan 2011 09:15:49 +0200
X-Google-Sender-Auth: 21c-tDo7Eo6SqmMWM6sVDuV6DtQ
Message-ID: <AANLkTimMmOugdHFnsO6qvd8U_USmcgz7GDXMQED1GEOE@mail.gmail.com>
Subject: Re: [BUG] implicit declaration of kfree/kzalloc in i2c-i801.c on Alpha
From: Pekka Enberg <penberg@kernel.org>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        mcree@orcon.net.nz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 8:18 AM, Bob Tracy <rct@gherkin.frus.com> wrote:
> Another 2.6.37-rc8 build failure on alpha:
>
> (...)
>  CC [M]  drivers/i2c/busses/i2c-i801.o
> drivers/i2c/busses/i2c-i801.c: In function 'i801_probe':
> drivers/i2c/busses/i2c-i801.c:737: error: implicit declaration of function 'kzalloc'
> drivers/i2c/busses/i2c-i801.c:737: warning: assignment makes pointer from integer without a cast
> drivers/i2c/busses/i2c-i801.c:855: error: implicit declaration of function 'kfree'
> make[3]: *** [drivers/i2c/busses/i2c-i801.o] Error 1
> make[2]: *** [drivers/i2c/busses] Error 2
> make[1]: *** [drivers/i2c] Error 2
> make: *** [drivers] Error 2

Adding a

  #include <linux/slab.h>

in drivers/i2c/busses/i2c-i801.c should help. Care to send a tested
patch to do that?
