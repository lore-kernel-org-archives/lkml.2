Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0L1Ngp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 08:36:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0L1Ngk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 08:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m7TBtrKwNmpYoQ1TYSPU5hcvpLu+NbXojL8qE0Y62IQMZu1ARPCBvtfJ0gGcF/D2QT
         lJ/9fKUrE6+iElgBGpmMS4UZu1oA/FWlQ4HbeNTPwIcXLsAIFIUn6+a4I/F++4jwUGzL
         76cIOSQEgqsspLIwEn1xEbCZaJgFAiIyag5qE=
Date: Tue, 28 Dec 2010 14:36:31 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Richard Cochran <richard.cochran@omicron.at>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] Cleanup ADJ_SETOFFSET patch
Message-ID: <20101228133631.GA27825@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
 <20101228112000.GA17470@riccoc20.at.omicron.at>
 <20101228125332.GA26363@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228125332.GA26363@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 01:53:32PM +0100, Richard Cochran wrote:
> {sec, nsec}        sum
> -------------------------
> {-2, +600000000}  -1.4
> {-2, +700000000}  -1.3
> {-2, +800000000}  -1.2
> {-2, +900000000}  -1.1
> {-1,  000000000}  -1.0
> {-1, +100000000}  -0.9
> {-1, +200000000}  -0.8
> {-1, +300000000}  -0.7
> 
> If we say that the time value or interval in a timespec is always the
> sum of the fields, still it would seem that the ktime code is broken
> according to that assumption.

Okay, now I think I get it.

The value of a timespec is the sum of its fields. The tv_nsec field
should always be non-negative.

So, if a user space program wants to jump the clock back by one-tenth
second, it must pass a timespec with value {-1,900000000}.

Right?

Thanks,
Richard
