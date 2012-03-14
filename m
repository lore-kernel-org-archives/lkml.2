Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535Ab2CNVht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:37:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36988 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab2CNVhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:37:48 -0400
Date: Wed, 14 Mar 2012 21:37:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] vfs namespace: Don't assume mount namespace has valid
 root
Message-ID: <20120314213746.GK23916@ZenIV.linux.org.uk>
References: <1331758710-16400-1-git-send-email-levinsasha928@gmail.com>
 <20120314201048.GI23916@ZenIV.linux.org.uk>
 <20120314205809.GJ23916@ZenIV.linux.org.uk>
 <CA+1xoqcvXsx1vpAB7Jg-dWGVaadbF4sC3Cr2s5itHfdiPFQerA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcvXsx1vpAB7Jg-dWGVaadbF4sC3Cr2s5itHfdiPFQerA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:03:43PM +0200, Sasha Levin wrote:
> > And that's all pointers to mnt_namespace that ever exist, aside of function
> > arguments and local variables. ?I'm not saying that I couldn't have possibly
> > fucked it up, but from rereading that code it doesn't look like we could
> > end up with dangling pointers to already freed instances...
> 
> I'm trying to find the exact chain of events leading it it at the
> moment, but it reproduces rather easily - so if you have any ideas on
> figuring it out I'm happy to try anything.

Which kernel, for starters?  I'd probably add dumping call chain +
return value in alloc_mnt_ns(), call chain + pointer being freed in
final put_mnt_ns() and failure exit of dup_mnt_ns(), address of
mnt_ns and value assigned to ->root on assignments to ->root in
create_mnt_ns() and dup_mnt_ns() and mnt_ns in dup_mnt_ns() if it
happens to have NULL ->root.

That should give you full history of allocation/freeing mnt_namespace
instances and of assignments to anyone's ->root.  Ought to make a sane
starting point...
