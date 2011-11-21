Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1KUWnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:43:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45851 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1KUWnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:43:42 -0500
MIME-Version: 1.0
In-Reply-To: <4ECACF68.3020701@gmail.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
 <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com> <4ECACF68.3020701@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 14:43:19 -0800
X-Google-Sender-Auth: 4nJ396d7TGSmnGCruP_G8itBPmE
Message-ID: <CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and HPAGE_SIZE
To: David Daney <ddaney.cavm@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, linux-arch@vger.kernel.org,
        Robin Holt <holt@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 2:23 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>
> This whole comment strikes me as somewhat dishonest, as at the time David
> Rientjes wrote it, he knew that there were dependencies on these symbols in
> the linux-next tree.
>
> Now we can add these:
> +#define HPAGE_SHIFT    ({ BUG(); 0; })
> +#define HPAGE_SIZE     ({ BUG(); 0; })
> +#define HPAGE_MASK     ({ BUG(); 0; })

Hell no.

We don't do run-time BUG() things. No way, no how.

If that #define cannot be used, then it damn well shouldn't be defined at all.

David's patch is clearly the right thing to do. Don't try to send me
the above kind of insane crap.

                     Linus
