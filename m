Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab1JRBVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:21:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59065 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752169Ab1JRBVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:21:14 -0400
Message-ID: <1318900873.1846.1.camel@Joe-Laptop>
Subject: Re: [patch] Avoid using hardcoded values in kernel/sys.c
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Henrik Grindal Bakken <henribak@cisco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Oct 2011 18:21:13 -0700
In-Reply-To: <alpine.DEB.2.00.1110171752300.19024@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110171752300.19024@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 17:55 -0700, David Rientjes wrote:
> The release field of struct new_utsname may always change, so avoid
> hardcoded values when setting up a buffer to copy to it.

I don't think this is correct.

> diff --git a/kernel/sys.c b/kernel/sys.c
[]
> -static int override_release(char __user *release, int len)
> +static int override_release(char __user *release)
>  {
> +	const int len = sizeof(release);
>  	int ret = 0;
> -	char buf[65];
> +	char buf[len];

sizeof(release) = 4 or 8


