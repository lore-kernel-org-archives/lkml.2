Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2EAUTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:19:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63319 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2EAUTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FA04373.6090100@redhat.com>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
 <d280fa846e9093a3cc82d9e75da4bb8074c7d4c7.1335894230.git.dledford@redhat.com>
 <4FA04131.2040004@gmail.com> <4FA04373.6090100@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 May 2012 16:18:52 -0400
Message-ID: <CAHGf_=p34t2jrqr1V_TP0UiXLE8g1p6UXOV25SwWC8C9h2BVBQ@mail.gmail.com>
Subject: Re: [Patch 3/4] ipc/mqueue: strengthen checks on mqueue creation
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> But ENOMEM is more inaccurate. It almostly is used for kmalloc failure.
>
> I chose ENOMEM for that particular error because above there we have
> checked the passed in arguments to make sure that they don't violate our
> allowances for max message or max message size.  If we violate either of
> those items, we return EINVAL.  In this case, neither of the values is
> invalid, it's just that together they make an overly large allocation.
> I would see that as more helpful to a programmer than EINVAL when the
> values are within the maximums allowed.  At least with ENOMEM the
> programmer knows they have to reduce their combined message size and
> message count in order to get things working.

Incorrect. When ENOMEM is returned, programmers can't know
which problem was happen 1) kernel has real memory starvation
or 2) queue limitation exceed was happen. The problem is, you
introduced new overloaded error code for avoiding overload error code.
It doesn't make sense. My question was, why can't you choose no
overload error code if you want accurate one?
