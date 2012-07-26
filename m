Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2GZWzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:55:04 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:55766 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777Ab2GZWzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAMQu2gzh1=rkTuBr+RRtnzb0m9ZpqSY9X0o92q4BAQXNENoSQw@mail.gmail.com>
References: <1343251216-24106-1-git-send-email-ccross@android.com> <CAMQu2gzh1=rkTuBr+RRtnzb0m9ZpqSY9X0o92q4BAQXNENoSQw@mail.gmail.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Fri, 27 Jul 2012 00:54:39 +0200
Message-ID: <CAMQu2gwhHw7k-rtjFDMMqhjP=efDhWDW6=cQ0rFhFLqJ9k=FGA@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 9:25 AM, Shilimkar, Santosh
<santosh.shilimkar@ti.com> wrote:
> On Wed, Jul 25, 2012 at 11:20 PM, Colin Cross <ccross@android.com> wrote:
>> The cpu hotplug notifier gets called in both atomic and non-atomic
>> contexts, it is not always safe to lock a mutex.  Filter out all events
>> except the six necessary ones, which are all sleepable, before taking
>> the mutex.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
> Agree.
> Have you observed any lock-up ?
>
Colin explained me about cause of the issue in an off-list discussion.
Thought of updating the thread in case some one wants to reproduce the
issue. You get  a warning during cpu hotplug in suspend if you turn on
sleeping while atomic debugging option in kernel build and the patch
fixes it.

Regards
Santosh
