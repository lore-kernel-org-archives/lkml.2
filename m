Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2JPEJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:09:44 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55686 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2JPEJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:09:42 -0400
Date: Tue, 16 Oct 2012 00:08:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        tglx@linutronix.de, davem@davemloft.net, mingo@kernel.org,
        DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC] random: Account for entropy loss due to overwrites
Message-ID: <20121016040848.GE17446@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
	mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
	tglx@linutronix.de, davem@davemloft.net, mingo@kernel.org,
	DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
References: <1344878779-10700-1-git-send-email-hpa@linux.intel.com>
 <50675038.9000108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50675038.9000108@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 12:47:04PM -0700, H. Peter Anvin wrote:
> >-static struct poolinfo {
> >+static const struct poolinfo {
> >+	int poolshift;		/* log2(POOLBITS) */
> >  	int poolwords;
> >  	int tap1, tap2, tap3, tap4, tap5;

Poolshift is duplicated information; it's just log2(poolwords) + 5
(since POOLBITS is poolwords*32).

Granted you don't want to recalculate it every single time you need to
use it, but perhaps it would be better to add poolshift to struct
entropy_store, and set it in init_std_data()?

				- Ted
