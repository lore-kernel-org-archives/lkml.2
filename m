Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1I0XQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:16:01 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49873 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1I0XP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:15:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCHv2] fat: don't use custom hex_to_bin()
References: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
	<542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
	<87hb3xj41s.fsf@devron.myhome.or.jp>
	<CAHp75Vcdnx28i0s4sKUf+MCruMNq-zdX55f45TcTR7AcO4foSw@mail.gmail.com>
Date: Wed, 28 Sep 2011 08:15:55 +0900
In-Reply-To: <CAHp75Vcdnx28i0s4sKUf+MCruMNq-zdX55f45TcTR7AcO4foSw@mail.gmail.com>
	(Andy Shevchenko's message of "Tue, 27 Sep 2011 21:06:12 +0300")
Message-ID: <87bou5inkk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

> Actually here we will change endianess.
> So, my question is what endianess is right here? If the original code
> okay, then patch should be rewritten like this:
>
>      rc = hex2bin(op++, ip + 3, 1);
>      if (rc < 0)
>           return -EINVAL;
>
>      rc = hex2bin(op++, ip + 1, 1);
>      if (rc < 0)
>           return -EINVAL;

Original code may work only for little endian. Well, anyway, the output
should be wchar_t (u16) of native endian.

So, I think it should be something like

	u8 uc[2];
	if (hex2bin(uc, ip + 1, 2) < 0)
        	return -EINVAL;
	*(wchar_t *)op = uc[0] << 8 | uc[1];

This should be readable more.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
