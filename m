Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0JTClc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:41:32 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42980 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756303Ab0JTClb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:41:31 -0400
Date: Tue, 19 Oct 2010 21:41:28 -0500
From: Robin Holt <holt@sgi.com>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: More issues found on kernel.org
Message-ID: <20101020024128.GD14068@sgi.com>
References: <4CBC9CC7.7050204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBC9CC7.7050204@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:15:19PM -0700, J.H. wrote:
> Not that the current discussion on IMA, and the recent problems found
> with XFS were enough, I've started seeing, rather regularly, what I've
> reported in bugzilla
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=20702
> 
> It looks like a double free is happening somewhere, and the issue
> *SEEMS* to be limited to the dynamic web boxes (bugzilla, wiki's, etc)
> and those are the only boxes I have running drbd and ocfs2.
> 
> Once the initial problem hits, the box more or less grinds to a halt and
> will eventually kernel panic and reboot.  Explicitly trying to reboot
> the box results in a solidly hung box requiring a hard reset.
> 
> Anyone have any thoughts, any extra debugging if/when this should happen
> again that would be useful?

If you are building your own kernel, I would turn on slab debugging.
Nearly all the double frees I have come across in the last years have
been tracked down using slab debug which traps double frees.  It does
not always point at the culprit, but at least narrows the field.

Robin
