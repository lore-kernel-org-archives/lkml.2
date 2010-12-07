Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0LGJpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:45:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0LGJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:45:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 01/45] kstrtox: converting strings to integers done (hopefully) right
Date: Tue, 7 Dec 2010 10:45:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com> <201012071004.58311.arnd@arndb.de> <20101207093229.GB29776@core2.telecom.by>
In-Reply-To: <20101207093229.GB29776@core2.telecom.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071045.33870.arnd@arndb.de>
X-Provags-ID: V02:K0:3B7TcVgoIV4sj0K6UI7m5ejQ328JWKtU5werdsl1UNB
 FPW9aGVGblRRIPSxXYo/NI0idkPn1SGppyR3TDjowdEXY91Hyj
 5pLh91mqRluP6DiX/voul2Xe8AW9EzZEu0RW7xKJN+D0xucw4X
 y59F4E7RztkqEMrSfLt2bDLqjzZFkTqL/UvvU1zzTKxBMY7trX
 r1q6P+EdeNlqHnH2yZyRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 December 2010 10:32:29 Alexey Dobriyan wrote:
> On Tue, Dec 07, 2010 at 10:04:58AM +0100, Arnd Bergmann wrote:
> > On Monday 06 December 2010 16:16:36 Alexey Dobriyan wrote:
> >
> > > It is used by kstrtol() if "long" and "long long" aren't the same type.
> > > I can't ifdef it because gcc doesn't allow "#if sizeof(long long) == ".
> > > "Do not use" hints "use kstrtol()".
> > 
> > Can't you use #ifdef CONFIG_64BIT to see if long is 64 bit wide?
> 
> I could, but there are no defines for alignment.

Not sure what you mean here. All architectures always naturally align
'long' variables -- we rely on that elsewhere already. 'long long' is
misaligned on x86-32 and possibly some other 32 bit architectures, but
since that should not cause any problems.

Another option would be to export just the strto{u,s}{8,16,32,64}
functions and define the inline wrappers conditionally on CONFIG_64BIT.

	Arnd
