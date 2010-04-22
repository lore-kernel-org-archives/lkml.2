Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0DVAby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:31:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47618 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0DVAbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:31:53 -0400
To: Mike Chan <mike@android.com>
Cc: tony@atomide.com, paul@pwsan.com, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] omap: pm34xx: Enable IO / IO-CHAIN wakeups for PER
References: <1271295665-26187-1-git-send-email-mike@android.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 21 Apr 2010 17:07:50 -0700
In-Reply-To: <1271295665-26187-1-git-send-email-mike@android.com> (Mike Chan's message of "Wed\, 14 Apr 2010 18\:41\:04 -0700")
Message-ID: <87aasw5oyx.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Chan <mike@android.com> writes:

> IO events can also come from GPIO modules, which reside in the PER domain.
> It is possible for the PER to enter RET while CORE is still in ON.
> If GPIO 2-6 are enabled for IO-pad wakeups, the PER domain will not
> wakeup in this case, unless we enable it.
>
> Signed-off-by: Mike Chan <mike@android.com>

Hi Mike,

I'm a little puzzled on this one.  My understanding is that the IO pad
is only armed when CORE is in RET or OFF.

I need to dig a little more in the TRM on this one to clarify.

If CORE is staying on, it might be that your GPIO module level wakeups
are not being configured correctly.  Please check the 'Known Problems'
section of the OMAP PM wiki[1], search for 'GPIO module-level wakeups'

Kevin

[1] http://elinux.org/OMAP_Power_Management#Known_Problems
