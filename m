Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2JLVFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:05:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2JLVFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:05:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
Date: Fri, 12 Oct 2012 21:05:08 +0000
Message-ID: <1557307.tHJJu7g4Ig@wuerfel>
User-Agent: KMail/4.9 beta2 (Linux/3.5.0-7-generic; KDE/4.8.90; x86_64; ; )
In-Reply-To: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:j8Cb2ZXOPCFsv1OhYVODklJov7Q4zGiYrrlZEWg7hV1
 s6qTln7U23XB63l2XIesEPmQENkML8lBMx7Kks/VxVPlrO+GOm
 q/zfDT3hAkvq2AqcWzZ8DKganeinDeaEmC0ZeGaYKZYDm41MnZ
 MACiCt2Yzsep15dSI1mw19TV86JcenuMtmdEapuDVp26ETZ9gN
 cPPsZeTRSreOW+qpSp4dTPt7cYAXvwVJ07sp0XO+12P5jk+XEf
 282an3AKkeHP7lk45nqJUTnqJFvSVHz3SeuBZT13PaYddSsvFI
 IqSlawLp/IWoK25pv3CZuP8HrbCoI0JOs+lu6cck4fdfE+ArZt
 iFxUYs+qT8UFX7j1V1cY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2012 20:56:44 김재극 wrote:
> +struct f2fs_nat_entry {
> +       __u8 version;
> +       __le32 ino;
> +       __le32 block_addr;
> +} __packed;
> +
> +struct f2fs_nat_block {
> +       struct f2fs_nat_entry entries[NAT_ENTRY_PER_BLOCK];
> +} __packed;

Using "__packed" on structure is rather inefficient on CPU architectures
that cannot do aligned accesses. I would suggest you remove this
attribute everywhere you can. The f2fs_nat_entry is particularly
suboptimal because it is 9 bytes long, and I'm not sure if this
can be reasonably changed to a multiple of four.

In all other cases, you should try to lay out the structures
so that each member is naturally aligned and you don't need any __packed
attributes, in particular for those that are accessed a lot.

	Arnd
