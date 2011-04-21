Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1DUNJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1DUNJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:09:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTi==rGJLQfDXohFZwqCT3m27XWUB4sASzomHWCor@mail.gmail.com>
References: <AANLkTi==rGJLQfDXohFZwqCT3m27XWUB4sASzomHWCor@mail.gmail.com> <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com> <1264.1301495438@redhat.com>
To: Valerie Aurora <valerie.aurora@gmail.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 00/74] Union mounts version something or other
Date: Thu, 21 Apr 2011 14:09:34 +0100
Message-ID: <8873.1303391374@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valerie Aurora <valerie.aurora@gmail.com> wrote:

> That's never up to date, but I just fixed it.  The branch you want is
> "ext2_cleanup".  Any branch with "+" at the front is a mistake from
> trying to do a git push of a rebased branch.  I deleted it.

Okay, I've got that pulled up to Linus's head branch.  I've mostly got the RCU
pathwalk and managed dentry stuff correctly entangled.

However, I have a few questions:

 (1) Is it meant to be possible to unionmount over a mount tree rather than
     just a single mount?  I ask because do_lookup_union() calls
     __follow_mount().

 (2) When you open a file that exists in the lower layer but not the top
     layer, am I right in thinking that f_path points to the lower layer file?

 (3) If I'm correct in (2), I presume something must intercept fchown() and
     suchlike?

 (4) I presume IS_DIR_UNIONED() only gives true on the upper layer (the one
     that was mounted -o union)?

David
