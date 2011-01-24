Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab1AXFyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 00:54:03 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54693 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1AXFyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 00:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QrAa0d14ZlNIjuprt8R5igjV495dwQZaFikaatAih6rgJBA5oCFaoCKK+ybKtmqM7G
         bEssO/37eODgMqHiKudUcm1b3xf2twTz9Iy4akn7Htu49pWbZdXc3da6cLw9VHIm7fkF
         oyCVRnqEp4shr/IWsHaYgBCoqxfrQKwWze6lM=
MIME-Version: 1.0
In-Reply-To: <1295847626-2396-1-git-send-email-yong.zhang0@gmail.com>
References: <20110123150341.GA2643@zhy>
	<1295847626-2396-1-git-send-email-yong.zhang0@gmail.com>
Date: Mon, 24 Jan 2011 07:54:00 +0200
X-Google-Sender-Auth: YgIafQLNd3C6N2sjstbLdbG_JBA
Message-ID: <AANLkTi=gRO0tCdEzmn3Ne6Wj6bXd1G8nhLw2E_-Yw3WA@mail.gmail.com>
Subject: Re: [PATCH V2] sched: fix autogroup nice tune on UP
From: Pekka Enberg <penberg@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mfwitten@gmail.com,
        christian@nerdbynature.de, a.p.zijlstra@chello.nl,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Jan 24, 2011 at 7:40 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> +static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
> +{
> +       struct task_group *tg;
> +       struct sched_entity *se;
> +
> +       if (!cfs_rq)
> +               return;
> +
> +       tg = cfs_rq->tg;
> +       se = tg->se[0];
> +       if (!se)
> +               return;
> +       if (likely(se->load.weight == tg->shares))
> +               return;
> +       reweight_entity(cfs_rq_of(se), se, tg->shares);
> +}

Wouldn't it be cleaner if we'd separate the shares calculation in a
separate helper function that's just

  return tg->shares;

for UP and extract the current logic for the SMP version?
