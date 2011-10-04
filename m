Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1JDHdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:33:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1JDHdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:33:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/26] ARM: pxa: CPU_PJ4 requires IWMMXT
Date: Tue, 4 Oct 2011 09:33:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Jason Chagas <jason.chagas@marvell.com>, linux-kernel@vger.kernel.org
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <20295619.jOfPxmug8T@wuerfel> <CAMPhdO96WwmPVqVpM2Vpef3wSgfHEf-0tK5VewXn-EGMns2ubA@mail.gmail.com>
In-Reply-To: <CAMPhdO96WwmPVqVpM2Vpef3wSgfHEf-0tK5VewXn-EGMns2ubA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110040933.38389.arnd@arndb.de>
X-Provags-ID: V02:K0:B9JgxvGj3f0Y266MP61iKyOay8liL6dg0HAFuhoWeFj
 rD9ytk9fkdg9WjbrnijTXUw0/R7iL+DKPwskAROkVsCTbX+KnE
 PhHbiKR8oYcoHfs5li2RNO9khwRgBIgmNfEZr9I0/DM8Wbo8pQ
 waC2upuL4sj0JrMR9mViMYjDGGgJ3/pD0Bw4Q4BNgcWyFiCUca
 /Zp3q71Krc58vtMIgfvD3wIYQGqirHt2UxA9QFqM47qBiowe+E
 cOqtTO8Yfb28g3u9QL6/YxqYXjvXBjFLNzknDowNVN5fSrxIy3
 1Qf7m2xTm5GmbJTuqwc1WTHLdXKLShNc53u/8AzyE3FMjOlz5G
 bF6J+indJvN56Efu6mr8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011, Eric Miao wrote:
> I think this is true for other xscale CPUs as well, so either we make
> them unconditionally all at once, or we still leave an option here.

Do all xscale have iwmmxt?

> It actually looks quite odd to me that CPU_PJ4 is made special here,
> what're the real broken builds errors?

Yes.

I should probably have provided a longer description of the problem.
The build error is in arch/arm/kernel/pj4-cp0.c, which calls
iwmmxt_task_release unconditionally. The code is obviously
copy-pasted from arch/arm/kernel/xscale-cp0.c, which does much
of the same, but uses both run-time and compile-time conditionals
for iwmmxt.

	Arnd
