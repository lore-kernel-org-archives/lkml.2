Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab2CBVN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:13:29 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:27756 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757142Ab2CBVN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:13:28 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yObizVEVM1l.4la84sP825o_APR6rt2mpgZ_FQX7Pz1_jf6
 r1qRat0zfo6cBQdYajGj2iYUEacfL7j4vVWps1mbSZeLLv7fxSNJoZeK0S6s
 xXJilymsHHBXZgWHHDfGycS1XeaLyZ0.OBzGEqJflUs7VQ9KHVEF3bg_Nmvy
 WWFxnJl7sSN97e027pdjhFmD2QGurJEvip2ZY4aVrv3263IRAPK5ucoOyLc4
 4YSfJ2CAcd1EVRAv_HZCHE6I7OdYlkKhGzK_hK_mB5ErQuFcIJAaJZYa5g6g
 5OxJRqs8mzbAuEyYk8US7q263NKTRFUAn.juB.8gZ959.e_dR_KQrNSaZxl2
 V7j243L1s3bDcxQhKgggRmB6Y6Gs5i9VYfcZvXNrgGzVJ27jYhRywAWB1vnc
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 2 Mar 2012 15:13:25 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: John Stultz <john.stultz@linaro.org>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/9] time: Condense timekeeper.xtime into xtime_sec
In-Reply-To: <1330672368-32290-2-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.00.1203021510540.20257@router.home>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org> <1330672368-32290-2-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012, John Stultz wrote:

> +static inline void tk_normalize_xtime(struct timekeeper *tk)
> +{
> +	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
> +		tk->xtime_nsec -= (u64)NSEC_PER_SEC << tk->shift;
> +		tk->xtime_sec++;
> +	}
> +}

Could we avoid the loop?

y = ((u64)NSEC_PER_SEC << tk->shift));
tk->xtime_sec += tk->xtime_nsec / y;
tk->xtime_nsec %= y;

