Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab2DUP17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 11:27:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62666 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2DUP16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 11:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvx+-P3SvLUPhZF5MW68Ss-9m59BfOY1SeqtjVtWaQk+qA@mail.gmail.com>
References: <1335008543-13399-1-git-send-email-valentin.ilie@gmail.com>
	<CAFLxGvx+-P3SvLUPhZF5MW68Ss-9m59BfOY1SeqtjVtWaQk+qA@mail.gmail.com>
Date: Sat, 21 Apr 2012 18:27:56 +0300
X-Google-Sender-Auth: PXMje9ZbXq3inMIaKWkFEIHIBJM
Message-ID: <CAHuBVBZtCJ_o2DR9+z+BokS05JbCn2-zAh5sBnpwZo97-YaReA@mail.gmail.com>
Subject: Re: [PATCH] kernel: sys.c: Fixed coding style issues
From: Valentin Ilie <valentin.ilie@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This kind of patch is not easy to review.
> Can you please prove that no logic has changed?
> E.g. By comparing the object file before and after your patch...

Everything seems to be OK.

The diff is because the old version had an unnecessary \n in two places.

$ checkpatch.pl -q --file --terse /tmp/test/sys.c | grep total
total: 33 errors, 18 warnings, 2057 lines checked
$ checkpatch.pl -q --file --terse /tmp/test/sys_patched.c | grep total
total: 4 errors, 14 warnings, 2055 lines checked

$ diff -iEbwB sys.c sys_patched.c
215,216c215
< 			else if ((who != cred->uid) &&
< 				 !(user = find_user(who)))
---
> 		else if ((who != cred->uid) && !(user = find_user(who)))
280,281c279
< 			else if ((who != cred->uid) &&
< 				 !(user = find_user(who)))
---
> 		else if ((who != cred->uid) && !(user = find_user(who)))


-- 
Valentin Ilie
