Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0KCVyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:54:52 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:50916 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0KCVyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:54:50 -0400
To: fengguang.wu@intel.com
Cc: mrubin@google.com, david@fromorbit.com, axboe@kernel.dk,
        kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1] /proc/vmstat failure.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201011010053.ADE86905.JMLFHVtSQOOFOF@I-love.SAKURA.ne.jp>
	<201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp>
	<20101103174643.GA4985@localhost>
In-Reply-To: <20101103174643.GA4985@localhost>
Message-Id: <201011040654.GDB05271.SOFJFFtOMLHOQV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 4 Nov 2010 06:54:48 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> On Wed, Nov 03, 2010 at 07:11:11PM +0800, Tetsuo Handa wrote:
> > Hello.
> > 
> > "cat /proc/vmstat" triggered below failure.
> > 
> > BUG: unable to handle kernel paging request at 07c06d16
> > IP: [<c050c336>] strnlen+0x6/0x20
> 
> It seems that m->private is of type (void *) while the original v is
> (unsigned long *). Can be fixed by the following patch.

Fixed by this patch. Thank you.

By the way, GCC treats "(void *) + offset" as "(char *) + offset"
but it is GCC specific extention. Maybe we should avoid such usage
in order to avoid build failure for other compilers.
