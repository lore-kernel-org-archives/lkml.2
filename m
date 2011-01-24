Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1AXIBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 03:01:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48925 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1AXIBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 03:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=U+IWSYow4e73FQ243TLC4tU6RHohrCkdz3bgzd9wODMiy93NIcHt5t6vGj273XT4Xe
         Io5dsLI8I5JSkN9CD8+vcvcVxoiD0gpcMci4FYNUOg9+mNvG8sMq1ivkJTRpxGve5RAZ
         FUdpgJtOIMNh5MCYdQ4cnGRw56dUtsMDCZZig=
MIME-Version: 1.0
In-Reply-To: <20110124073352.GA24186@windriver.com>
References: <20110123150341.GA2643@zhy>
	<1295847626-2396-1-git-send-email-yong.zhang0@gmail.com>
	<AANLkTi=gRO0tCdEzmn3Ne6Wj6bXd1G8nhLw2E_-Yw3WA@mail.gmail.com>
	<AANLkTi=3f8nvEuFbHqjnTXtrK_sAC-A9+XAMjAHgjT3d@mail.gmail.com>
	<AANLkTikLnOXOAeBgMQCcOqgNP1WrVf9QeFEkgthTbU2N@mail.gmail.com>
	<20110124073352.GA24186@windriver.com>
Date: Mon, 24 Jan 2011 10:01:14 +0200
X-Google-Sender-Auth: 8YeMRbHZsWJM5O5bZ5Z0T87DG1Q
Message-ID: <AANLkTi=8aMP9v5zyfWeUXzithhDiOM0eFQYeqsCMCtG2@mail.gmail.com>
Subject: Re: [PATCH V3] sched: fix autogroup nice tune on UP
From: Pekka Enberg <penberg@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mfwitten@gmail.com,
        christian@nerdbynature.de, a.p.zijlstra@chello.nl,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Jan 24, 2011 at 08:18:11AM +0200, Pekka Enberg wrote:
>> I proposed extracting the shares calculation logic in
>> update_cfs_shares() to reduce code duplication for the SMP and UP
>> patch. So something like this:

On Mon, Jan 24, 2011 at 9:33 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> Thanks for your example.
> So something like this?
>
> ---
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH V3] sched: fix autogroup nice tune on UP
>
> When on UP with FAIR_GROUP_SCHED enabled, tune shares
> only affect tg->shares, but is not reflected on
> tg->se->load, the reason is update_cfs_shares()
> do nothing on UP.
> So introduce update_cfs_shares() for UP && FAIR_GROUP_SCHED.
>
> This issue is found when enable autogroup, but also
> exists on cgroup.cpu on UP.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mike Galbraith <efault@gmx.de>

Looks good to me! FWIW,

Acked-by: Pekka Enberg <penberg@kernel.org>
