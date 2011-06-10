Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab1FJNAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:00:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:53150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab1FJNAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:00:39 -0400
Date: Fri, 10 Jun 2011 15:00:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Murray <amurray@mpcdata.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Murray <amurray@mpc-data.co.uk>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Bootgraph.pl bug fix
In-Reply-To: <1307655610-28446-1-git-send-email-amurray@mpcdata.com>
Message-ID: <alpine.LNX.2.00.1106101459570.22872@pobox.suse.cz>
References: <1307655610-28446-1-git-send-email-amurray@mpcdata.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Andrew Murray wrote:

> This patch removes the assumption of the bootgraph.pl script that the
> timing information reported by PRINTK_TIME will contain at least one
> entry with a time of less than 100 seconds.
> 
> Not all boards correctly reset the system timer and in many cases the
> inital times reported by PRINTK_TIME is high. When this occurs the
> bootchart.pl script fails to give any useful output.
> 
> This patch sets the $firsttime variable to the largest value expected
> by PRINTK_TIME
> 
> Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
> ---
>  scripts/bootgraph.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
> index 12caa82..b78fca9 100644
> --- a/scripts/bootgraph.pl
> +++ b/scripts/bootgraph.pl
> @@ -44,7 +44,7 @@ my %end;
>  my %type;
>  my $done = 0;
>  my $maxtime = 0;
> -my $firsttime = 100;
> +my $firsttime = 99999;
>  my $count = 0;
>  my %pids;
>  my %pidctr;

Adding Arjan to CC. Arjan, if you are OK with the patch, I can take it 
through my tree with your Ack.

Thanks,

-- 
Jiri Kosina
SUSE Labs
