Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1AOWIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 17:08:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53219 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1AOWIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 17:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R3LpVd66deCQ1uLIVr0IWWaq0DBNFU/zbKbymVYo+NfTNCtv9ZMJCjg8muIEg9UH8T
         EHb9gVyiESCMXarXopd7boLrFfSPJW98scyq22vhai+XbZfRg76BLEBkkficJPk8wufJ
         Eg4vJLDzntQV4cvbL6zh61rg9SQqZjO+ZJkPI=
Date: Sat, 15 Jan 2011 14:08:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de,
        jbarnes@virtuousgeek.org, rubini@cvml.unipv.it,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Request for unicore32 architecture codes to merge into linux-next
Message-ID: <20110115220809.GC19872@core.coreip.homeip.net>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 16, 2011 at 01:00:31AM +0800, Guan Xuetao wrote:
> Hi,
> 
> I want to merge unicore32 repo into linux-next tree, the position is (unicore32 branch):
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
> 

Have these changes been reviewed at all? Looking at the input parts I
doubt it... We try _really_ hard to avoid sprinkling arch #ifedefs in
the common code.

So, for input:

- how big is the difference between standard keytable and the one you
  are introducing? Looks like you are just adding 5 new keys that are
  not critical for booting. So please just update keymap from userpsace
  as we do for countless laptops and keyboards out there.

- Trying to enable mouse 1000 times can lead to loooong delays. Have
  you tried to figure out why you need the loop?

- What kind of mice can be connected to teh devices? I am concerned that
  your super-strict protocol checks will cause more harm then good (i do
  not believe they are valied in general case, overflow is just and
  additional bit).

Please split changes related into logically separated patches and post
them on linux-input@vger.kernel.org (along with linux-kernel if you
prefer) for review and comments.

Thanks.

-- 
Dmitry
