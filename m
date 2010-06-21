Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab0FUI4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 04:56:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44605 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab0FUI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 04:56:33 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Aleksandr Koltsoff <aleksandr.koltsoff@ebts.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: Exporting NOCMTIME to userspace
References: <4C1F087E.7070000@ebts.fi>
Date: Mon, 21 Jun 2010 10:56:25 +0200
In-Reply-To: <4C1F087E.7070000@ebts.fi> (Aleksandr Koltsoff's message of "Mon,
	21 Jun 2010 09:36:46 +0300")
Message-ID: <871vc0darq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aleksandr Koltsoff <aleksandr.koltsoff@ebts.fi> writes:
>
> On the other hand, if someone can suggest a way to avoid timestamp
> updates/causing inode writes, I'm all ears and eyes. (using the
> block-layer directly or writing a custom fs is not really an elegant
> solution, IMO).

I recently looked at this for some other reason. One of the reasons
c/m time became a problem recently are sub second time stamps
in newer file systems, which can be a performance problem
on some extreme loads (updating the time stamp requires taking
locks and takes CPU time)

I think what would be better would be to have flush intervals
that specify that m/c time are only flushed with longer 
intervals (similar to the deferred atime that's now in there)

This would still cause the inode to be written if it gets flushed from
memory on low memory and occasionally depending on the interval, but
most of the writes would be gone. All still with the same semantics.

I think doing it this way would be preferable over just
disabling it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
