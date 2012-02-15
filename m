Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab2BOMgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 07:36:41 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52472 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2BOMgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 07:36:38 -0500
X-Nat-Received: from [202.181.97.72]:53998 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1329309379.17259
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
        tomoyo-dev-en@lists.sourceforge.jp, jmorris@namei.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] security: TOMOYO should clean policy files
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4F3ACCE2.6040200@xenotime.net>
In-Reply-To: <4F3ACCE2.6040200@xenotime.net>
Message-Id: <201202152136.BCD65110.OQOOHFSLFFVMJt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 15 Feb 2012 21:36:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 15022012 #6951784, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> TOMOYO creates some empty/default policy files during build.
> It should remove them during 'make clean'.
> 
> I noticed that they were not being removed because the
> "Creating ..." messages always occurred a maximum of one time
> during 25 randconfig builds, so it was sometimes using the
> files from a previous build (which is not a problem, but
> still, 'make clean' should remove them).

Thank you. But I prefer current behavior.

The content of automatically generated files depends on neither kernel config
nor architecture. They are static contents which are used when a user did not
explicitly supply contents. Therefore, I think we don't need to delete them by
'make clean'.
