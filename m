Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1LIXW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:22:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1LIXWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:22:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@lst.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2] ipc: provide generic compat versions of IPC syscalls
Date: Sat, 10 Dec 2011 00:21:35 +0100
Message-ID: <1690400.7yOAjHVqTH@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <20111209134852.f5b5bcbc.akpm@linux-foundation.org>
References: <201112091536.pB9Fa5f7002738@farm-0002.internal.tilera.com> <201112091903.pB9J39pd031553@farm-0002.internal.tilera.com> <20111209134852.f5b5bcbc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/15MQ54WxZ/BuawCVfAT2GidHxMZcpVi5BanFd0QBCc
 Zd45DWJOnZ6RritkMak2rkAPnsxFUHt18OrYd7I3dWSm5c+vYT
 EK2DRbdPqHzyex8Hya3ropKP72s2P74h2HyxRR7YGpm9MQcppr
 iG5zjpraZIS4yNsePCRHQ2s3WbDnMN2yBhaGpweC3WO0LomrxH
 +2eMs4mZsI7bo52wEEw7nnDqGclXQKPl1yuuG/89VLUfsQmcrL
 9A/qXsUHnG2nPZCcan6apdxrtyMggzq7moOu8e6SsTISmVpszZ
 trS3YoI4kwCnxw32z5iyCEumVT8bG2LGPiHTxParLcaBf4QPIS
 iQTjBpKG6+wKBVFR8tJc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 December 2011 13:48:52 Andrew Morton wrote:
> What would we need to do to get all architectures using the new
> interfaces, and remove __ARCH_WANT_OLD_COMPAT_IPC?

We would change the various compat_sys_ipc functions (mips, powerpc,
s390, sparc, x86) to call the new functions instead of the existing
ones, and test each architecture. For parisc, we might not
actually need the either version, but I'd have to take a closer look
to be sure.

> Regarding the implementation: rather than patching the header
> files, it would be more conventional (and arguably better) to add
> 
>         select ARCH_WANT_OLD_COMPAT_IPC
> 
> to arch/*/Kconfig, then use CONFIG_ARCH_WANT_OLD_COMPAT_IPC.

Yes.

	Arnd
