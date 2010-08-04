Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0HDP0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:26:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42594 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0HDP0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:26:34 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vaurora@redhat.com,
        Valdis.Kletnieks@vt.edu
In-reply-to: <1276627208-17242-28-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Tue, 15 Jun 2010 11:39:57 -0700)
Subject: Re: [PATCH 27/38] union-mount: In-kernel file copyup routines
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-28-git-send-email-vaurora@redhat.com>
Message-Id: <E1OgfrQ-0000sG-Jx@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Aug 2010 17:26:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010, Valerie Aurora wrote:
> When a file on the read-only layer of a union mount is altered, it
> must be copied up to the topmost read-write layer.  This patch creates
> union_copyup() and its supporting routines.
> 
> Thanks to Valdis Kletnieks for a bug fix.

What happens if there's a crash in the middle of the copyup?

Possible solution is using rename to atomically "replace" the
underlying file.  That however introduces namespace issues: where to
put the temporary file which then needs to be deleted on "fsck.union"?

Miklos
