Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2HFGeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:34:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35000 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2HFGeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 02:34:36 -0400
Date: Mon, 6 Aug 2012 07:34:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mq: INFO: possible circular locking dependency detected
Message-ID: <20120806063433.GW23464@ZenIV.linux.org.uk>
References: <501D0093.2090108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501D0093.2090108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 12:59:31PM +0200, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest, using latest -next kernel, I've stumbled on the dump below.
> 
> I think this is the result of commit 765927b2 ("switch dentry_open() to struct path, make it grab references itself").

	Not quite, actually - back then the order didn't matter;
unfortunately, I'd missed that place when porting Jan's series,
which made these ordered.

	Anyway, see today's vfs.git#for-linus; that should be dealt with
there.
