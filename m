Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1FANdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:33:51 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23068 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1FANdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:33:49 -0400
Date: Wed, 1 Jun 2011 15:25:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sysctl: remove impossible condition check
In-Reply-To: <1306934105-6280-1-git-send-email-lucas.demarchi@profusion.mobi>
Message-ID: <alpine.LNX.2.00.1106011521160.12980@swampdragon.chaosbits.net>
References: <1306934105-6280-1-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Lucas De Marchi wrote:

> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> ---
>  fs/proc/proc_sysctl.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 2e5d3ec..98e82d4 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -52,11 +52,8 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
>  {
>  	int len;
>  	for ( ; p->procname; p++) {
> -
> -		if (!p->procname)
> -			continue;
> -
>  		len = strlen(p->procname);
> +
>  		if (len != name->len)
>  			continue;

How about compacting it even further by getting rid of the 'len' variable 
as well?
Like this:

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 proc_sysctl.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f50133c..bd7f7af 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -49,17 +49,11 @@ out:
 
 static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 {
-	int len;
 	for ( ; p->procname; p++) {
-
-		if (!p->procname)
-			continue;
-
-		len = strlen(p->procname);
-		if (len != name->len)
+		if (strlen(p->procname) != name->len)
 			continue;
 
-		if (memcmp(p->procname, name->name, len) != 0)
+		if (memcmp(p->procname, name->name, name->len) != 0)
 			continue;
 
 		/* I have a match */


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

