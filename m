Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0IYDo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 23:44:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49732 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0IYDo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 23:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YjfGtIOI1YdMPtpWZWXc+WYW+ASics/3M9VbGYPo+4zRgKk3RXNZ7NClu52/HlDkcy
         9rqyjeLD5sultQyw1xZO0BUXSKyQ+ECgupRrGZE6uIsiIqSO8U9pYMJuzs2GEaggx42v
         TmHfKCEaU6xf9DHaJCGCD0N/p+Kvp6vwTnGAY=
MIME-Version: 1.0
In-Reply-To: <20100925032638.GT19804@ZenIV.linux.org.uk>
References: <1285384856-4310-1-git-send-email-namhyung@gmail.com> <20100925032638.GT19804@ZenIV.linux.org.uk>
From: Namhyung Kim <namhyung@gmail.com>
Date: Sat, 25 Sep 2010 12:44:36 +0900
Message-ID: <AANLkTikn9ZYEW9--eEgadadheo3ymFpkOaaQ0zZoNQS=@mail.gmail.com>
Subject: Re: [PATCH RESEND] signal: annotate siglock acquisition
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 12:26, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Sep 25, 2010 at 12:20:56PM +0900, Namhyung Kim wrote:
>> lock_task_sighand() conditionally acquires sighand->siglock in case of
>> returning non-NULL but unlock_task_sighand() releases it unconditionally.
>> This leads sparse to complain about the lock context imbalance. Annotate it
>> to make sparse happier.
>
> That's not a good way to do it; use __cond_lock instead.
>

Thanks. I'll resend a patch that uses it.


-- 
Regards,
Namhyung Kim
