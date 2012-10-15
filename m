Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2JOLs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:48:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38935 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752432Ab2JOLs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:48:58 -0400
Message-ID: <1350301737.6851.9.camel@joe-AO722>
Subject: Re: [PATCH] init: main: fixed coding style issues and errors
From: Joe Perches <joe@perches.com>
To: "\"Levan Giguashvili" <levangig@gmail.com>
Cc: rusty@rustcorp.com.au, mingo@kernel.org, jim.cromie@gmail.com,
        viro@zeniv.linux.org.uk, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Oct 2012 04:48:57 -0700
In-Reply-To: <1350290504-13931-1-git-send-email-user@ubuntu>
References: <1350290504-13931-1-git-send-email-user@ubuntu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 10:41 +0200, "Levan Giguashvili wrote:
> From: Odinn <odinn@ubuntu.(none)>

who's that?  Make sure your from line is correct please.

> Fixed coding style issues regarding spaces and braces.
> Removed init of a static variable.
> Added KERN_DEBUG to printk that was missing it

Added unnecessary continuation lines to printks.

> diff --git a/init/main.c b/init/main.c
[]
> @@ -172,8 +172,8 @@ static int __init obsolete_checksetup(char *line)
>  				if (line[n] == '\0' || line[n] == '=')
>  					had_early_param = 1;
>  			} else if (!p->setup_func) {
> -				printk(KERN_WARNING "Parameter %s is obsolete,"
> -				       " ignored\n", p->str);
> +				printk(KERN_WARNING "Parameter %s is obsolete" \
> +				       ", ignored\n", p->str);

Don't add unnecessary line continuations please.
Better would be to coalesce the formats like:
				printk(KERN_WARNING "Parameter %s is obsolete, ignored\n"
				       p->str);

It would also be better and easier to review if you
broke out the whitespace only changes as a separate
patch from the other changes you make.

Oh, and please make these sorts of changes only in
the drivers/staging tree until you are _very_ familiar
with kernel style.  Don't rely on checkpatch to tell
you what to do.  It's pretty brain-dead.  checkpatch
is a patch checking tool not really a code style tool
for existing code.


