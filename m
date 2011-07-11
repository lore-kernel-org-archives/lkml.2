Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1GKDXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:23:51 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64491 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab1GKDXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <4E15FBFE.4090203@linux.intel.com>
References: <20110705062148.GA6056@program>
	<20110707131455.GB4078@tiehlicka.suse.cz>
	<4E15FBFE.4090203@linux.intel.com>
Date: Mon, 11 Jul 2011 11:23:48 +0800
Message-ID: <CAEQi4bfm7zp-Lq-Hn8JD7Dq7fOzyt2-X9Kk_jB07S_S55uC81w@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix memory leak of init_vdso_vars()
From: wzt wzt <wzt.wzt@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        hpa@zytor.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe, we can just panic() when kmalloc failed instead of add a new GFP_PANIC.

new patch will coming soon.

On Fri, Jul 8, 2011 at 2:33 AM, Andi Kleen <ak@linux.intel.com> wrote:
> When you run out of memory at early system boot (this is early
> system boot only) the system is toast anyways. There's no way
> to recover.
>
> I would just add a few GFP_PANICs and then drop the error paths.
>
> -Andi
>
>
