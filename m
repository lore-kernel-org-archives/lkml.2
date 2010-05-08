Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0EHWGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 18:06:17 -0400
Received: from mail.perches.com ([173.55.12.10]:2054 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab0EHWGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 18:06:16 -0400
Subject: Re: [PATCH] get_maintainer.pl: optionally ignore non-maintainer
 tags
From: Joe Perches <joe@perches.com>
To: florian@mickler.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
In-Reply-To: <1273354364-6016-1-git-send-email-florian@mickler.org>
References: <4BE46E7D.1040906@s5r6.in-berlin.de>
	 <1273354364-6016-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 15:06:13 -0700
Message-ID: <1273356373.704.56.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 23:32 +0200, florian@mickler.org wrote:
> Using --git to determine who to send a patch to, it is not
> reasonable to include people that only reported an issue or tested a
> patch. Thus we restrict the candidates to be the one's listed with
> Reviewed-By, Signed-Off-By and Acked-By tags.
[]
> +    my $tagPattern;
> +    if ($email_git_maintainers) {
> +	    $tagPattern = join("|",@maintainer_tags);
> +    } else {
> +	    $tagPattern = "[^ \t]+";

I think the else case should be "[a-z _-]+" as some
non-standard signatures have embedded spaces.

