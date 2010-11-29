Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0K2Qd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:33:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:32755 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0K2Qd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:33:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,276,1288594800"; 
   d="scan'208";a="354496322"
Date: Mon, 29 Nov 2010 08:33:24 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101129163308.GA2383@xanatos>
References: <20101116104600.GA24015@suse.de>
 <20101119191906.GA31760@xanatos>
 <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
 <20101126074809.GD19589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101126074809.GD19589@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 08:48:09AM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, Nov 19, 2010 at 11:19 AM, Sarah Sharp
> > <sarah.a.sharp@linux.intel.com> wrote:
> > >
> > > .config and dmesg are attached.  The box is running klogd 1.5.5ubuntu3
> > > (from Jaunty).  Yes, I know that's old.  I read the bit in the commit
> > > about changing the permissions of kallsyms after boot, but if I can't
> > > boot that doesn't help.  Perhaps this can be made a configuration
> > > option?
> > 
> > It's not worth a config option.
> > 
> > If it actually breaks user-space, I think we should just revert it.
> 
> Sarah,
> 
> Does your system boot fine if we make /proc/kallsyms simply an empty file to 
> unprivileged users? Something like the (untested ...) patch below.

Yes, that works.  The system boots as normal. `cat /proc/kallsyms`
returns an empty file, and `sudo cat /proc/kallsyms` does not.

Sarah Sharp


> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 6f6d091..d54c993 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -465,7 +465,7 @@ static int s_show(struct seq_file *m, void *p)
>  	struct kallsym_iter *iter = m->private;
>  
>  	/* Some debugging symbols have no name.  Ignore them. */
> -	if (!iter->name[0])
> +	if (!iter->name[0] || !capable(CAP_SYS_ADMIN))
>  		return 0;
>  
>  	if (iter->module_name[0]) {
