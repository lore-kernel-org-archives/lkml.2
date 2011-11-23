Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1KWCts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 21:49:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38460 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1KWCtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 21:49:46 -0500
Message-ID: <1322016578.6445.99.camel@work-vm>
Subject: Re: [PATCH] rtc: Fix some bugs that allowed accumulating time drift
 in suspend/resume
From: John Stultz <john.stultz@linaro.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Date: Tue, 22 Nov 2011 18:49:38 -0800
In-Reply-To: <1322015091-23560-1-git-send-email-arve@android.com>
References: <1322015091-23560-1-git-send-email-arve@android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
x-cbid: 11112302-1780-0000-0000-000001216462
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000234; HX=3.00000178; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00089938; UDB=6.00024040; UTC=2011-11-23
 02:49:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 18:24 -0800, Arve Hjønnevåg wrote:
> The current code checks if abs(delta_delta.tv_sec) is greater or
> equal to two before it discards the old delta value, but this can
> trigger at close to -1 seconds since -1.000000001 seconds is stored
> as tv_sec -2 and tv_nsec 999999999 in a normalized timespec.
> 
> rtc_resume had an early return check if the rtc value had not changed
> since rtc_suspend. This effectivly stops time for the duration of the
> short sleep. Check if sleep_time is positive after all the adjustments
> have been applied instead since this allows the old_system adjustment
> in rtc_suspend to have an effect even for short sleep cycles.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>

Looks good to me! Thanks for fixing and sending this in!
I'll queue it for upstream.

thanks
-john

