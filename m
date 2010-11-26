Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab0KZR1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:27:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49556 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab0KZR1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:27:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UgFfGzune+/9vQ/fniraBhUw/PlJWBJ44opJT7MCGvgafS9YNdAe+iw5nkqVDFlqzZ
         lEcPOEp9O1rQnaRl9bM2ELD8LpJvCXBtA0Fj+eg+Gk8WiE9PnVzRsLYYvrmCMzU5ZsgA
         +uRPKa6Z1fgcW8xgDPlrVhs6vx0U1STkJHZIw=
MIME-Version: 1.0
In-Reply-To: <201011261757.08303.roucaries.bastien@gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<20101118163048.GE5374@nowhere>
	<201011261757.08303.roucaries.bastien@gmail.com>
Date: Fri, 26 Nov 2010 18:27:13 +0100
Message-ID: <AANLkTi=_zh3mG++THk75qChw93Rwb=VULuoJ_qZqPGXS@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 5:57 PM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> Dear frederic,
>> Hi Bastien,
>>
>> This really looks like a hung task detector report.
>> Several tasks are stuck in queue_log_writer(), waiting
>> to be woken up on the "journal->j_join_wait" event and
>> that never happens because the waker is also stuck.
>> The problem is your report doesn't show where the waker
>> is stuck, but the hung task detector reports it, it just
>> did before or after the chunk you've posted.
>>
>> If you could provide me the entire report, I could fix this
>> easily.
>
> I have manged to reproduce it after six hour of stress. Unfornatly locked was
> disabled due to a known non bug, in the init sequence. I have used sysrq -t in
> order to get more information to you.

Without debugging enable lock up take about 30 minutes to occurs but
are really hard to reproduce with debugging on

Bastien


> Do I need to try to reproduce it, with a newer kernel ? Or it is sufficient ?
>
