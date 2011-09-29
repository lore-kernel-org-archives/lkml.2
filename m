Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1I2Slu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:41:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41049 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753530Ab1I2Slt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:41:49 -0400
Message-ID: <1317321707.1867.1.camel@Joe-Laptop>
Subject: Re: [PATCHv4] fat: don't use custom hex_to_bin()
From: Joe Perches <joe@perches.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Sep 2011 11:41:47 -0700
In-Reply-To: <8762kb8aqj.fsf@devron.myhome.or.jp>
References: <87ipob8l4l.fsf@devron.myhome.or.jp>
	 <f176b6be3c0de274839e813d6ac514d6f7736e77.1317308975.git.andriy.shevchenko@linux.intel.com>
	 <1317310634.1854.25.camel@Joe-Laptop> <8762kb8aqj.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 03:27 +0900, OGAWA Hirofumi wrote:
> Joe Perches <joe@perches.com> writes:
> 
> >> +
> >> +					if (hex2bin(uc, ip + 1, 2) < 0)
> >>  						return -EINVAL;
> >> -					}
> >> -					*op++ = ec & 0xFF;
> >> -					*op++ = ec >> 8;
> >> +
> >> +					*(wchar_t *)op++ = uc[0] << 8 | uc[1];
> >
> > perhaps:
> >
> > 	__le16	foo;
> >
> > 	if (hex2bin((u8 *)&foo, ip + 1, 2) < 0)
> > 		return -EINVAL;
> > 	*(u16 *)op = le16_to_cpu(foo);
> >
> > 	op += 2;
> 
> I also thought about it. But I think it is not so good, like you had
> mistake.  It should actually be "__be16 foo" and "be16_to_cpu()".
> 
> If we used sscanf() instead of hex2bin(), I might agree to use
> "le16_to_cpu()" though.
> 
> Thanks.

Funny.

I guess that's what I get for reading Andy's comment
and coding that readably.

+                                       /* The ip contains 2 bytes in little
+                                        * endian format. We need to get them
+                                        * in native endian. */



