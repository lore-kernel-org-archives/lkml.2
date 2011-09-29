Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1I2PTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:19:12 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38336 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab1I2PTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:19:10 -0400
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
	<87ipob8l4l.fsf@devron.myhome.or.jp> <1317308040.2676.124.camel@smile>
Date: Fri, 30 Sep 2011 00:19:07 +0900
In-Reply-To: <1317308040.2676.124.camel@smile> (Andy Shevchenko's message of
	"Thu, 29 Sep 2011 17:54:00 +0300")
Message-ID: <87aa9n8jh0.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> On Thu, 2011-09-29 at 23:43 +0900, OGAWA Hirofumi wrote: 
>> I guess you just did copy&paste. "u8 uc[2];" part should be before
>> statement as C90.
>> 
>> I.e.
>> 
>> 				if (escape && (*ip == ':')) {
>>                                 	u8 uc[2];
>> 
>> 					if (i > len - 5)
>> 						return -EINVAL;
>> 
>> 					if (hex2bin(uc, ip + 1, 2) < 0)
>> 						return -EINVAL;
>> 					*(wchar_t *)op = uc[0] << 8 | uc[1];
> Actually, why do not use 
> *(wchar_t *)op++ = ... 
> instead of additional op+=2?

IMO, the reason would be, complex oneliner is possible to mistake. Well,
anyway, it doesn't work. It actually increments 1 byte as "char *", not
2 bytes as "wchar_t *".

>> 
>> 					op += 2;
>> 					ip += 5;
>> 					i += 5;
>> 				} else {
>> 
>> This should be work?
> Oh, my bad! So much minor mistakes last time. Really need vacation.

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
