Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2CFQC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:02:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2CFQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:02:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: lib/string.h build failure in linux-next
Date: Tue, 6 Mar 2012 16:02:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-next" <linux-next@vger.kernel.org>,
        "linux-arch" <linux-arch@vger.kernel.org>
References: <1331048540.17099.9.camel@deneb.redhat.com>
In-Reply-To: <1331048540.17099.9.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203061602.23512.arnd@arndb.de>
X-Provags-ID: V02:K0:ekWipsRRXMxd/z26F+GrSo/UBvJzuKST/xgAuL3++1X
 M4ZgzB0ClQyO2gCTrEGze4ju0fBN/zb7bk+U2ohuD92BZJbJ0Z
 iIoCTAFGlV37ZbtLevMbHRkvwvp9mTU0NvqtPTXeHZ8wRhMxA6
 5QUKer+1BBNZJGYlg0dsSnhUwga68Bm0UNjJh4oYSJ2cLoyYw1
 GBK+k+RIgzpzIh+FzBZUt/y4isH+nwwPniHCbbNVPQmb8KTEQ1
 IzrOCTeDvuqgaReJSUXIsq/edcW4QFcgY1zDe0PMscnRch8AfF
 /RySsc2DmWmtWkjL3rvcXfpeXxj7SwmJIs9Wi6CKdvuIGefG1K
 ww+sShtRxbw8uUUN6cfo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2012, Mark Salter wrote:
> I'm seeing a build failure in lib/string.h in linux-next:
> 
> /es/linux/linux-next/lib/string.c: In function 'strlcat':
> /es/linux/linux-next/lib/string.c:225:2: error: implicit declaration of function 'printk'
> /es/linux/linux-next/lib/string.c:225:2: error: implicit declaration of function 'panic'
> 
> Commit e2950c2b6ecb928bfd3a13dd237df1f29f712704 removed an include of
> linux/module.h which triggered the problem for arch/c6x and probably
> other architectures using the asm-generic BUG macro.
> 
> I think this needs fixing in asm-generic/bug.h which should include
> linux/kernel.h for panic and linux/printk.h for printk.

I think you cannot do that as long as linux/kernel.h includes asm/bug.h,
or you will get a lot of other build failures.

The safer option is probably to add the two missing headers separately
to string.c.

	Arnd
