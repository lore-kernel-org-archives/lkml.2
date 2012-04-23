Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2DWU0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:26:22 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:40981 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2DWU0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120423182630.GA13067@burratino>
References: <20120402150522.GA4980@burratino>
	<20120413193905.GD2387@burratino>
	<20120423182630.GA13067@burratino>
Date: Mon, 23 Apr 2012 13:26:18 -0700
X-Google-Sender-Auth: LqbBA3EoleQgRqKxXSLNEzVOIqU
Message-ID: <CAE9FiQVSdnqrno4VBZbcQmcYagpXPOo_Cvw=c9w_1GZycKv1Xg@mail.gmail.com>
Subject: Re: [PATCH resend v3] x86: memtest: WARN if bad RAM found
From: Yinghai Lu <yinghai@kernel.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:26 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
>
>  arch/x86/mm/memtest.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
> index c80b9fb95734..38caeb44a218 100644
> --- a/arch/x86/mm/memtest.c
> +++ b/arch/x86/mm/memtest.c
> @@ -30,6 +30,8 @@ static u64 patterns[] __initdata = {
>
>  static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
>  {
> +       WARN_ONCE(1, "Bad RAM detected. Use memtest86+ to perform a thorough test\n"
> +                 "and the memmap= parameter to reserve the bad areas.");

You must be kidding : calling memtest86+ "thorough test".

Yinghai
