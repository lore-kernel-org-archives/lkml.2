Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1CPH53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 03:57:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1CPH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 03:57:26 -0400
Subject: Re: [tip:perf/core] perf probe: Clean up probe_point_lazy_walker()
 return value
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-5e814dd597c42daeb8d2a276e64a6ec986ad0e2a@git.kernel.org>
References: <new-submission>
	 <tip-5e814dd597c42daeb8d2a276e64a6ec986ad0e2a@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 08:59:17 +0100
Message-ID: <1300262357.2250.58.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 23:18 +0000, tip-bot for Ingo Molnar wrote:

> perf probe: Clean up probe_point_lazy_walker() return value

> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1328,7 +1328,7 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
>  	 * Continue if no error, because the lazy pattern will match
>  	 * to other lines
>  	 */
> -	return ret < 0 ?: 0;
> +	return ret < 0 ? ret : 0;
>  }

It is a slight change in semantics though, the return value will now be
negative instead of 1. If its used as a boolean that's fine, but still.

I'd have changed it to:

  return ret < 0;

Which is identical to the previous statement.

