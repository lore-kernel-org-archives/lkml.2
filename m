Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1GXBsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 21:48:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36346 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1GXBs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 21:48:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=uy6TCoGlmgFJmWRqvzhOS9Av8GGzrBCMIVDw9nrJLYaztES2L9DVxg1IpxvOzSz0C
	XmWIZRvlPWxZk3irZO1RQ==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107232136490.26837-100000@netrider.rowland.org>
References: <CAMbhsRTdQLd5GRew9GMx6O287k3O17SKE18jvK2k7oyZpOrZfg@mail.gmail.com>
	<Pine.LNX.4.44L0.1107232136490.26837-100000@netrider.rowland.org>
Date: Sat, 23 Jul 2011 18:48:21 -0700
X-Google-Sender-Auth: g_SXdO9_khMUpTIyVZE5ks73yH4
Message-ID: <CAMbhsRT36FsptMbHGtbY8xV=Lso3h-OY8cKc_LAtVHnKV+rm4w@mail.gmail.com>
Subject: Re: [PATCH] PM: runtime: add might_sleep to PM runtime functions
From: Colin Cross <ccross@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 6:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 23 Jul 2011, Colin Cross wrote:
>
>> On Sat, Jul 23, 2011 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Saturday, July 23, 2011, Colin Cross wrote:
>> >> The list of functions that can be called in atomic context is
>> >> non-intuitive (pm_runtime_put_sync can not, but
>> >> pm_runtime_put_sync_suspend can, if pm_runtime_irq_safe has
>> >> been called?).
>> >
>> > However, this behavior is documented.
>> >
>> > Also, if you have a clean use case for calling rpm_idle() with interrupts
>> > off, it can be modified to work in analogy with rpm_suspend() in that respect.
>>
>> Yes, Kevin posted that patch in response to a bug that would never
>> have existed with this patch.  Even with Kevin's change, this patch
>> still detects drivers that are missing pm_runtime_irq_safe().
>
> I suggest that adding the annotations to __pm_runtime_idle(),
> __pm_runtime_suspend(), and __pm_runtime_resume() is entirely
> reasonable.  But the annotations to __pm_runtime_disable() and
> __pm_runtime_use_autosuspend() do seem unnecessary.

OK, I'll drop those.
