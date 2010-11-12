Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0KLMjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:39:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47453 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab0KLMjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:39:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fGK0OVhQ1r88o2aqr+mSHWF6qDoynKBlaqB/LST9GZzwF497uQXHU8mibh9auwOFLH
         9fUfZEm7OSrzl3X4s8Bhp/sBV43Dovq8byfyCwNKHLi5xZg3fBbSLsWHaJ8moafNI+5L
         CgF+L40XKD3QDIKkKTUfiBM/ugVL5duwpps0Y=
MIME-Version: 1.0
In-Reply-To: <1283396674-4865-1-git-send-email-ccross@android.com>
References: <1283396674-4865-1-git-send-email-ccross@android.com>
Date: Fri, 12 Nov 2010 13:39:50 +0100
Message-ID: <AANLkTinsRCinLdhq1xj0tx09Jb=Tohdbd7PUD=ae1q3m@mail.gmail.com>
Subject: Re: [PATCH] [ARM] twd: Allow twd rescaling to match cpu frequency
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Harald.Gustafsson@ericsson.com,
        Rickard ANDERSSON <Rickard.Andersson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

2010/9/2 Colin Cross <ccross@android.com>:

> The clock to the ARM TWD local timer scales with the cpu
> frequency.  To allow the cpu frequency to change while
> maintaining a constant TWD frequency, pick a lower target
> frequency for the TWD and use the prescaler to divide down
> to the closest lower frequency.
>
> This patch provides a new initialization function that takes
> a target TWD frequency and the relation between the cpu
> clock and the TWD clock, required to be an integer divider
>>= 2 by the ARM spec.  It also provides a function to be
> called from cpufreq drivers to set the prescaler whenever
> the cpu frequency changes.

What's the status of this patch?

We have basically the same problem so we'd really like
a generic solution to this problem.

Our only comment is that we cannot see the reason for
not using the CPUfreq notifiers as most scaling code
is, but I assume there is some specific reason for this?

Unless something holds this back, could you post it to
Russells patch tracker, we might have an add-on patch
for the U8500 later.

Yours,
Linus Walleij
