Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1JTMWC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 08:22:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1JTMWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 08:22:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 3/3] ARM 4Kstacks: Decrease poll and select stack usage, when using 4K stacks
Date: Thu, 20 Oct 2011 14:21:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
References: <4E9E0B71.9020708@am.sony.com> <4E9E0CEA.6030102@am.sony.com>
In-Reply-To: <4E9E0CEA.6030102@am.sony.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110201421.43747.arnd@arndb.de>
X-Provags-ID: V02:K0:H2TMhsLJhG5oA2hftZs4vrGRxKWJEtNwe4Q/KcEf9j/
 KLeKHbxIZyMcq8H+caBYa7Cdeg7T31OLe8CkLgXDJ+STy6QFHz
 kR5S/JM5ulSlQ8aSRv4If3ErNRcUgt3L4caF34jLvcvnal/N2v
 P/BEmNrmLv62QQpCIiVWw+sCJamILuM+cZ/oTxk0c415UEhHA4
 uF8a1FmpwV4EhcIw1TyMKaeNabEy55J17isrwQbwKpiwwQUES4
 hZMuawE1uL6H2pupCHDSzUyv1fMFLr6aPfL8oVIWxkMVZGDssR
 qoB3YwiyyQkamAUHuqwfQg/DzzlaOXAWPtpyAGXmZqJB7bM/xv
 R/CIMAufjJqxbhQvxxQw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 October 2011, Tim Bird wrote:
> Reduce the max allowed size for struct poll_wqueue to avoid
> using too much stack space in do_select() and do_sys_poll(),
> when the kernel is using 4K stacks.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>

Can you explain why this is necessary with 4K stacks? I would
expect the poll() function never to be deeply nested, so 1K
used in there doesn't sound too problematic.

	Arnd
