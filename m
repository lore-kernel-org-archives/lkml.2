Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0FUKcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:32:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49539 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab0FUKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:32:29 -0400
Date: Mon, 21 Jun 2010 12:32:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Aleksandr Koltsoff <aleksandr.koltsoff@ebts.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: Exporting NOCMTIME to userspace
Message-ID: <20100621103223.GA3211@basil.fritz.box>
References: <4C1F087E.7070000@ebts.fi>
 <871vc0darq.fsf@basil.nowhere.org>
 <4C1F2CE4.20502@ebts.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F2CE4.20502@ebts.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While this might solve the performance aspect of the problem, it will
> only migitate the reliability aspect with NANDs, since the inodes will
> eventually be flushed anyway (thus causing irreversible wear).

As long as you don't run out of memory it will happen very rarely.
Completely elimintating inode writes is not a good goal imho.

Iff you don't want inodes at all then perhaps consider using a LVM volume or similar 
instead of a file system.

> Also, a tunable like you're suggesting would affect all files on a
> single filesystem, instead of just a subset of files. Having an option
> to "disable" m/ctime updates per file would be optimal in our case,
> since we're talking about several years of runtime with the use case.
> There are other issues with rrdtool which make this hard, but those are
> all solvable without kernel modifications.

Yes, but the nice thing is that the semantics are the same, so unless
you crash you won't really notice.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
