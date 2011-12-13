Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1LMSHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:07:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab1LMSHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:07:09 -0500
Date: Tue, 13 Dec 2011 19:07:07 +0100
From: Jan Kara <jack@suse.cz>
To: Jorge Bastos <mysql.jorge@decimal.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reiserfs.c bug in 3.2-rc5
Message-ID: <20111213180707.GI11747@quack.suse.cz>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Sat 10-12-11 23:48:40, Jorge Bastos wrote:
> Have a VM in hyper-v, and with 3.2x reiserfs.c crashes.
> Attached there's the images, since I'm unable to copy text only.
> 
> What can be done here?
  The assertion failing is:
        BUG_ON(nblocks > journal->j_trans_max);
in do_journal_begin_r(). That means that reiserfs_create() tried to start a
transaction with more credits than allowed by the journal.

  When did you started to see this problem? Also do you use SELinux (or
generally security labels)?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
