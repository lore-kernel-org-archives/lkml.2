Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2IRSPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:15:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab2IRSPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:15:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] compat: fs: Generic compat_sys_sendfile implementation
Date: Tue, 18 Sep 2012 18:13:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1347987727-13739-1-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347987727-13739-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181813.06124.arnd@arndb.de>
X-Provags-ID: V02:K0:QL8Mz3tWxMXk9beQ7gpSO/Ba0VSVrkDlq70KAp3RkLx
 eAx6+LXzjPl1h5+hYCvM3JoGQ5t3I/2A91Vb0ZT34GFhhy0EuL
 kbIDUxCgTPD24WShJ0moYiJ5iON+Z1iAYCfdFb0jaZR2Gf8ubX
 wG8dfgZHP+1Tskh8hg+uoRHD9kc0tVz9xROhXCkYVyDFxJk8s8
 DH4VZQwyUiJOjFPtB+9mMUtZgrn0GWXNpwaLMrKRuiDAXrbc7I
 0Rkzgxq9FM/22NcBRgYZZoG6llM7o93OZ8Mwhh6drYvrmuaJiv
 7EVO+LEH7JRaCqqcT//iD/aaIgPV5I4hXlTUHn6XudA1lCqiKV
 GIpAHeyWPxSaaKqYEnYg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Catalin Marinas wrote:
> @@ -229,7 +229,7 @@ COMPAT_SYS_SPU(sched_setaffinity)
>  COMPAT_SYS_SPU(sched_getaffinity)
>  SYSCALL(ni_syscall)
>  SYSCALL(ni_syscall)
> -SYS32ONLY(sendfile64)
> +SYS32ONLY(sendfile64_wrapper)
>  COMPAT_SYS_SPU(io_setup)
>  SYSCALL_SPU(io_destroy)
>  COMPAT_SYS_SPU(io_getevents)

I believe this will break native ppc32 builds because there is
no sys_sendfile64_wrapper function. You probably have to use

SYSX(sys_ni_syscall, compat_sys_sendfile64_wrapper, sys_sendfile64)

	Arnd
