Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2GQQYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:24:43 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39477 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab2GQQYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:24:40 -0400
Date: Tue, 17 Jul 2012 12:24:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?Adri=E1n?= <adrianbn@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Setreuid distinction about (uid_t)-1
Message-ID: <20120717162437.GA6049@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?Adri=E1n?= <adrianbn@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAFDTedp84TuxHpz2SJTG_jdjtkQ7r9qkCjqQWT5Zg22LrT7tTg@mail.gmail.com>
 <20120717135201.GF1638@fysh.org>
 <CAFDTedowCyNgBtiPQUPVUv1XocMEhQJfyawjYxEkaXFX5E8H1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAFDTedowCyNgBtiPQUPVUv1XocMEhQJfyawjYxEkaXFX5E8H1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 03:13:18PM +0100, Adrián wrote:
> 
> Thanks a lot Athanasius. What I still can't see is why is the -1
> exception there, as I assume that if you want to leave one of the ids
> unchaged you can call:
> 
> setreuid(0,geteuid());
> 
> If you want to leave euid unchanged, right? Is there a need or reason
> to be doing this differentiation in the setreuid code?

Unix systems for multiple decades have done things this way, and it's
ensrined in POSIX and the Single Unix Specification.  Changing it
would potentially open up security holes for programs which expect the
standard-specificed behavior.

(Note, BTW, that decades ago system calls weren't cheap, and CPU's
were much slower, and that may have driven the historical behavior.
Sometimes we get forget how spoiled we are that Linux's system call
overhead is as low as it is...)

					- Ted
