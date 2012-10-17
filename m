Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2JQNod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:44:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43309 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2JQNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:44:31 -0400
Subject: Re: [RFC PATCH v2] posix timers: allocate timer id per task
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <20121017131732.8781.75295.stgit@localhost.localdomain>
References: <20121017131732.8781.75295.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Oct 2012 15:44:26 +0200
Message-ID: <1350481466.26103.464.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 17:18 +0400, Stanislav Kinsbursky wrote:

> +static int hash(struct signal_struct *sig, unsigned int nr)
> +{
> +	int hash = hash_ptr(sig, POSIX_TIMERS_HASH_BITS);
> +	return hash ^ hash_32(nr, POSIX_TIMERS_HASH_BITS);
> +}
> +

This is quite expensive on 64 bit arches. I suggest instead :

return hash_32(hash32_ptr(sig) ^ nr, POSIX_TIMERS_HASH_BITS);


