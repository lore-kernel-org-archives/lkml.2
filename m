Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab1GRVIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:08:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42019 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1GRVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110718210051.GA815@srcf.ucam.org>
References: <1311021033-7483-1-git-send-email-mjg@redhat.com>
	<1311021033-7483-5-git-send-email-mjg@redhat.com>
	<CA+8MBbJMHK1e_wGC9EE+8neVc2j9Y8Ut4vzPiGh2umNZENsK1Q@mail.gmail.com>
	<20110718210051.GA815@srcf.ucam.org>
Date: Mon, 18 Jul 2011 14:08:20 -0700
X-Google-Sender-Auth: DKCivU7amx4b1odwXin3Wf384pM
Message-ID: <CA+8MBbKY3fv0ezKpcrrOKCieGhrNaEFcP+y0KtcxQNEi5aPpRw@mail.gmail.com>
Subject: Re: [PATCH 4/9] pstore: Allow the user to explicitly choose a backend
From: Tony Luck <tony.luck@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mikew@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 2:00 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Jul 18, 2011 at 01:58:28PM -0700, Tony Luck wrote:

>> We don't allow backends to be unregistered (currently) - Do you think it would
>> be helpful to mention in this text that you cannot change your mind and
>> switch to a different back end once you have registered one? Writing
>> to /sys/module/... sounds a lot more flexible than what reality will allow.
>
> Mm. Yes, the lack of unregistration does make that less helpful. Perhaps
> best to make that unwritable.

Perhaps .... writable would be useful in this sequence:

1) Load pstore (or pstore is built in)
2) write to /sys/module/pstore/parameters/backend to chose backend
3) load other modules (including multiple pstore backends)

But that seems rather contrived - a user doing this could just adjust step 3
to only load the preferred backend (or make sure the preferred one goes first).

-Tony
