Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1EKPuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:50:14 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58975 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab1EKPuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=M1eZ17b1YGgGhdwxNVbl51Y70+coHL+UjiIA/8aNvMUOCKbMG0dgGJL0E2zXiJFis/
         MZZfcszHnqwnaSQPe59+W8BDBcEB3smJK1eyQWE+5+xrw/3J/JvB08PDFNKljAKwgMg1
         RW35ZEvmwLvB8Q+kswHVjbHJ6UhsNRRMrG+MM=
MIME-Version: 1.0
In-Reply-To: <1305109433.2914.208.camel@laptop>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org> <1305109433.2914.208.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 11 May 2011 13:58:47 +0200
Message-ID: <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 12:23, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-05-02 at 19:44 +0000, tip-bot for Thomas Gleixner wrote:
>> Commit-ID:  99ee5315dac6211e972fa3f23bcc9a0343ff58c4
>> Gitweb:     http://git.kernel.org/tip/99ee5315dac6211e972fa3f23bcc9a0343ff58c4
>> Author:     Thomas Gleixner <tglx@linutronix.de>
>> AuthorDate: Wed, 27 Apr 2011 14:16:42 +0200
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Mon, 2 May 2011 21:39:15 +0200
>>
>> timerfd: Allow timers to be cancelled when clock was set
>>
>> Some applications must be aware of clock realtime being set
>> backward. A simple example is a clock applet which arms a timer for
>> the next minute display. If clock realtime is set backward then the
>> applet displays a stale time for the amount of time which the clock
>> was set backwards. Due to that applications poll the time because we
>> don't have an interface.
>
> Shouldn't that clock applet use CLOCK_MONOTONIC for the timer anyway?

Like: Hey let's meet at the bar 5 hours after bootup? :)

Kay
