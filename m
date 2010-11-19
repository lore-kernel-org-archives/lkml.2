Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0KSTzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:55:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756494Ab0KSTzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:55:16 -0500
MIME-Version: 1.0
In-Reply-To: <20101119191906.GA31760@xanatos>
References: <20101116104600.GA24015@suse.de> <20101119191906.GA31760@xanatos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Nov 2010 11:54:26 -0800
Message-ID: <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        w@1wt.eu, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:19 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
>
> .config and dmesg are attached.  The box is running klogd 1.5.5ubuntu3
> (from Jaunty).  Yes, I know that's old.  I read the bit in the commit
> about changing the permissions of kallsyms after boot, but if I can't
> boot that doesn't help.  Perhaps this can be made a configuration
> option?

It's not worth a config option.

If it actually breaks user-space, I think we should just revert it.
It's kind of sad to default to the world-visible thing, but as I
mentioned in the commit, this is something where a sysadmin or distro
can trivially just fix it at boot-time too, with just a

   chmod og-r /proc/kallsyms

in your bootup scripts.

And if somebody has taken control of the machine _before_ the bootup
scripts get to run, you have bigger problems than a /proc/kallsyms
file.

So I guess I'll revert it.

Thanks for testing and bisecting.

                      Linus
