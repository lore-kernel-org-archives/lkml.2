Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab1A0HNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:13:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65204 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1A0HNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:13:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X4kzDPb9mAT0zf4EM4cki/v6LficgYpP/gBXJJ1E48+87NU2OucU4ir45kMST1DEId
         bdNImOVR5acSFYiE4TppcfCxEDlkqgcs4R2feIctJpc4sprK2nJxNR3cwfFfAYXK2RVo
         /vvchm0YO9CSe1tXlnMk1fIZscV2LnmMKyW8A=
MIME-Version: 1.0
In-Reply-To: <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
References: <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
Date: Thu, 27 Jan 2011 15:13:11 +0800
Message-ID: <AANLkTi=Dz5Ybk6SEg0efd8fEBa8C-xzj-nyWnxsWsgao@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Untangle cpu-load and timekeeping code
From: Yong Zhang <yong.zhang0@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 8:14 PM, tip-bot for Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:
> Commit-ID:  18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> Gitweb:     http://git.kernel.org/tip/18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Tue, 25 Jan 2011 11:30:35 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 26 Jan 2011 12:33:23 +0100
>
> sched: Untangle cpu-load and timekeeping code
>
> Remove the calc_global_load() call from the timekeeping code and make
> it local to the scheduler.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Now another question comes into my head:

Previous we stop load calculation only when we goes to full idle,
say every CPU goes to idle. tick_do_timer_cpu is jumping to
the no-idle one so we can always get the real load.

But now, if the CPU on which the global_load_timer resident
goes to idle and there is still no-idle cpu in system, the load
calculation stops. So it's not reflecting the real load after
that.

Thanks,
Yong

-- 
Only stand for myself
