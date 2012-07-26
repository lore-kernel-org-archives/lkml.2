Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2GZTvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:51:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45980 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2GZTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:51:18 -0400
MIME-Version: 1.0
In-Reply-To: <201207262155.31280.rjw@sisk.pl>
References: <1343251216-24106-1-git-send-email-ccross@android.com>
	<201207262155.31280.rjw@sisk.pl>
Date: Thu, 26 Jul 2012 12:51:17 -0700
X-Google-Sender-Auth: 8PWtt55KzNRrY5bsmM7tTxIA8u8
Message-ID: <CAMbhsRRsxC0hCKx-Y_pY8z9F9Sbs52fWhCerGvKbt2fH6AWF5Q@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, July 25, 2012, Colin Cross wrote:
>> The cpu hotplug notifier gets called in both atomic and non-atomic
>> contexts, it is not always safe to lock a mutex.  Filter out all events
>> except the six necessary ones, which are all sleepable, before taking
>> the mutex.
>
> I wonder what mutual exclusion mechanis we rely on when the mutex is not taken?

We don't need any mutual exclusion because the notifier returns immediately.
