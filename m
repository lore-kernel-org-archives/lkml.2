Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0CPNGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:06:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:51220 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0CPNGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:06:13 -0400
Subject: Re: CONFIG_MTD_DEBUG vs generic DEBUG support in kernel.h
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <878w9swhlv.fsf@tac.ki.iif.hu>
References: <878w9swhlv.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 15:05:59 +0200
Message-ID: <1268744759.20017.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Mar 2010 13:05:15.0963 (UTC) FILETIME=[524CE8B0:01CAC509]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 13:55 +0100, Ferenc Wagner wrote:
> Hi,
> 
> include/linux/mtd/mtd.h contains the following snippet:
> 
> #ifdef CONFIG_MTD_DEBUG
> #define DEBUG(n, args...)                               \
>         do {                                            \
>                 if (n <= CONFIG_MTD_DEBUG_VERBOSE)      \
>                         printk(KERN_INFO args);         \
>         } while(0)
> 
> which conflicts with the generic debugging support in
> include/linux/kernel.h:
> 
> #ifdef DEBUG
> #define pr_devel(fmt, ...) \
>         printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> 
> (that is, gcc emits redefinition warnings on modules which
> #define DEBUG on their own and also include mtd.h)
> Unfortunately, the DEBUG macro is used rather heavily under
> drivers/mtd.  Should we resolve this somehow or is it better
> to just live with it?
> 
> (Please keep me on Cc, I'm not subscribed.)

IMO, this MTD debug stuff is not very useful and could be just killed.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

