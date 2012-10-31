Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935510Ab2JaMPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:15:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935482Ab2JaMPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:15:20 -0400
Date: Wed, 31 Oct 2012 13:15:17 +0100
From: Jan Kara <jack@suse.cz>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121031121517.GD18424@quack.suse.cz>
References: <20121023094351.GC27919@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023094351.GC27919@pcnci.linuxbox.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 23-10-12 11:43:51, Nikola Ciprich wrote:
> while trying to create consistent backups of KVM guest, I've discovered
> that fsfreeze always hangs.. deeper investigation revealed psacct to be the culprit.
> When psacct is disabled, fsfreeze works fine, when enabled, the command never returns.
> I suppose that the problem is /var is not on separate partition (ie it's same volume
> as /) and psacct isn't able to dump process exit information about fsfreeze command
> thus creating deadlock..
> problem is 100% reproducible on both latest 3.0.x kernel and 3.7-r1c.
> 
> Should more debugging information be needed, I'll be glad to provide whatever I can..
  Thanks for report. Hum, I'm not sure how the deadlock can happen because
AFAIU audit sends a message via netlink to userspace and whatever audit
daemon does with it is its private thing. Can you please run:
  echo w >/proc/sysrq-trigger
after the machine deadlocks and then take dmesg and attach it here? You'll
have to have the shell prepared and use serial console / netconsole to gather
dmesg or try your luck with copying via ssh / netcat.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
