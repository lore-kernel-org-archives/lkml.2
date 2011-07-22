Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1GVWem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:34:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49775 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1GVWel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:34:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Lgd5af0jndMCD5D7YYT3agxE2g8t/lGnt1LfhvWbdrh5RMPu9PXrrOiYOaC7N+YuD
	WX0X1hdaBWTfHkywx3Cww==
MIME-Version: 1.0
In-Reply-To: <20110722195340.GF3765@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
	<20110722195340.GF3765@redhat.com>
Date: Fri, 22 Jul 2011 15:34:37 -0700
Message-ID: <CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 12:53 PM, Don Zickus <dzickus@redhat.com> wrote:

> So I played with the hardlockup case and I kinda like the timestamp thing.
> It seems to give useful data.  In fact I feel like I can shrink the
> hardlockup window, run some tests and see where the latencies are in a
> system.  The patch itself I think is ok, I'll review on Monday or Tuesday
> when I get some more free time.
>
> However, I ran the softlockup case and the output was a mess.  I think
> rcu_sched stalls were being detected and as a result it was NMI dumping
> stack traces for all cpus.  I can't tell if it was your patch or some
> uncovered bug.
>
> I'll dig into on Monday.  Not sure if you were able to see that.
>
> Thanks,
> Don
>
I'm not sure what you mean. One problem could be the wording I used.
For the soft stalls I just called it LOCKUP, mostly to be very showy
in order to cover that case where it's unclear what exactly is
happening. This doesn't do much to distinguish soft and hard lockups,
and I see LOCKUP otherwise seems to refer to hard lockup, so maybe
that's misleading.
