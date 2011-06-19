Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1FSPHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:07:10 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:58123 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754169Ab1FSPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:07:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DEoAwd/Ye6fH3dgfZmaKoZjMdEV7dOW+U4Z8IXqdHEQORTcIl81wPYzLmfp3cZjrA99FLQMbTdniPOytNllEonBdiRaZN693BSs9DjpbI4vEipj0F0/64M98XiNyCqXa;
Date: Sun, 19 Jun 2011 08:07:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: halfdog <me@halfdog.net>, linux-ext4@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Can someone confirm ext4 BUG_ON on latest kernel build?
Message-Id: <20110619080704.33753b99.rdunlap@xenotime.net>
In-Reply-To: <4DFDCBE0.5020806@halfdog.net>
References: <4DFDCBE0.5020806@halfdog.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding ext4 mailing list]


On Sun, 19 Jun 2011 10:13:52 +0000 halfdog wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Sorry, I do not have latest kernel. Can someone confirm this on latest?
> At least bugtracker does not know about it, and to my understanding of
> source, should be still here.
> 
> 
> dd if=/dev/zero bs=1M count=64 of=test
> mkfs.ext4 -F test
> echo -n " " | dd of=test bs=1 count=1 seek=297195 conv=notrunc
> mount -o loop test /mnt/test
> dmesg -c
> 
> On ubuntu natty with latest kernel, it seems, that
> fs/ext4/super.c:__save_error_info calls mod_timer before timer->function
> is set at end of fs/ext4/super.c:ext4_fill_super via
>   sbi->s_err_report.function = print_daily_error_info;
> 
> This causes BUG_ON(!timer->function) in kernel/timer.c:__mod_timer
> Device is stuck, not usable any more.
> 
> Thanks
> 
> - -- 
> http://www.halfdog.net/
> PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
> 
> iD8DBQFN/cvFxFmThv7tq+4RAgfvAJ97N9bnKq4kN99XneTMyJZ5Hha9MQCfcguN
> L4trkTeOsIqDWF8m6VUqcgc=
> =zvYY
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
