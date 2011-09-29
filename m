Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1I2On2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:43:28 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60703 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1I2On1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:43:27 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCHv2] fat: don't use custom hex_to_bin()
References: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
	<542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
	<87hb3xj41s.fsf@devron.myhome.or.jp>
	<CAHp75Vcdnx28i0s4sKUf+MCruMNq-zdX55f45TcTR7AcO4foSw@mail.gmail.com>
	<87bou5inkk.fsf@devron.myhome.or.jp> <1317301641.2676.120.camel@smile>
Date: Thu, 29 Sep 2011 23:43:22 +0900
In-Reply-To: <1317301641.2676.120.camel@smile> (Andy Shevchenko's message of
	"Thu, 29 Sep 2011 16:07:21 +0300")
Message-ID: <87ipob8l4l.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

>> So, I think it should be something like
>> 
>> 	u8 uc[2];
>> 	if (hex2bin(uc, ip + 1, 2) < 0)
>>         	return -EINVAL;
>> 	*(wchar_t *)op = uc[0] << 8 | uc[1];
>> This should be readable more.
> It might be so, but it's not okay to do such constructions in C
>
> fs/fat/namei_vfat.c:535:1: warning: ISO C90 forbids mixed declarations
> and code [-Wdeclaration-after-statement]
>
> So, I will resend patch as I proposed with additional comments.

I guess you just did copy&paste. "u8 uc[2];" part should be before
statement as C90.

I.e.

				if (escape && (*ip == ':')) {
                                	u8 uc[2];

					if (i > len - 5)
						return -EINVAL;

					if (hex2bin(uc, ip + 1, 2) < 0)
						return -EINVAL;
					*(wchar_t *)op = uc[0] << 8 | uc[1];

					op += 2;
					ip += 5;
					i += 5;
				} else {

This should be work?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
