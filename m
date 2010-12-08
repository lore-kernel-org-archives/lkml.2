Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0LHW4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:56:54 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:58170 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0LHW4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=mjGP0jyp0vVZc+cHfQgRc/KkxXL3JV4gS0ZzlfKAQPSxJJXhwr35OLxelASaB2sPTY
         Iro7X5fWYObX+c4oR1FEaE7IbqsdMmnyqU6sXONyiK/QOxdV1z8na2XtjRacjsvT8FYH
         h8qu/djMfborZaTjDnGZ0b/0ySgH/wTA7QiCA=
MIME-Version: 1.0
In-Reply-To: <20101208145040.e23f832d.akpm@linux-foundation.org>
References: <20101203141828.33E8F9D401B@zog.reactivated.net> <20101208145040.e23f832d.akpm@linux-foundation.org>
From: Daniel Drake <dsd@laptop.org>
Date: Wed, 8 Dec 2010 22:56:50 +0000
X-Google-Sender-Auth: _3J9WjKSQ222dmrpwzX8c-4g-Wk
Message-ID: <AANLkTinh9RyGAKeL4weN5bWQ=pAn0NwKdb8Ru4RKkDP3@mail.gmail.com>
Subject: Re: [PATCH v5 resend] OLPC: Add XO-1 suspend/resume support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2010 22:50, Andrew Morton <akpm@linux-foundation.org> wrote:
> x86_64 allmodconfig gives me
>
> {standard input}: Assembler messages:
> {standard input}:300: Error: suffix or operands invalid for `mov'

Thanks, will check. this indeed won't work on x86_64, need to get it
excluded there.

> Also, this checkpatch warning
>
> WARNING: struct platform_suspend_ops should normally be const
> #502: FILE: arch/x86/platform/olpc/xo1.c:106:
> +static struct platform_suspend_ops xo1_suspend_ops = {
>
> seems valid.

When you correct it (to make it const), gcc gives a warning, because
suspend_set_ops() takes non-const arg. I was thinking that casting
const to non-const would be worse than checkpatch warning.

Also working on the extensive feedback from Thomas, next version will
be cleaner and clearer.

Thanks!
Daniel
