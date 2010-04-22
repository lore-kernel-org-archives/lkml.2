Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0DVKvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:51:12 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:62728 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab0DVKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Eq5uHO5f6eUkmozIyWnpDQR3wQppRVjd5MMnI+8EfXkVBTP8FzgAVL7+SaouMSuJwm
         C1FJrfBK0r6YKlukW5DMmwIZLxZ2eYYiSEvHMbg5/U6gZEN2ejdIM2130yuplkEH9dhR
         Al35IY7zhYaxThuq5npaag/R1nLZD6YC4bZlo=
MIME-Version: 1.0
In-Reply-To: <20100422013721.GC8938@windriver.com>
References: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
	 <20100422013721.GC8938@windriver.com>
Date: Thu, 22 Apr 2010 11:51:06 +0100
Message-ID: <r2l87a5b0801004220351h4ba2d1ect49c33893a30806e9@mail.gmail.com>
Subject: Re: Threaded irq handler question
From: Will Newton <will.newton@gmail.com>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 2:37 AM, Yong Zhang <yong.zhang@windriver.com> wrote:
> On Wed, Apr 21, 2010 at 05:35:32PM +0100, Will Newton wrote:
>> Hi all,
>> My problem is that this structure does not work, because once I call
>> disable_irq_nosync() on the irq in the check handler the thread will
>> no longer run because the irq is disabled. However if I don't call
>> disable_irq_nosync() I will get endless irqs because the line is
>> level-triggered and will not be deasserted until the thread has run.
>>
>> Could someone tell me what I'm doing wrong here?
>
> Does IRQF_ONESHOT meet your need?

Almost I think, but I believe if my check handler does not wake the
thread then I don't get another interrupt ever. I can fix this by
making my check handler always return WAKE_THREAD, which is slightly
sub-optimal, but not a big problem.

Thank you for your help!
