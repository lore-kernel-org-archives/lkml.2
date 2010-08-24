Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0HXBNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:13:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0HXBNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:13:35 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 1/4] fanotify: flush outstanding perm requests on group destroy
Date: Tue, 24 Aug 2010 03:13:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1282523830-27751-1-git-send-email-eparis@redhat.com>
In-Reply-To: <1282523830-27751-1-git-send-email-eparis@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008240313.11593.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010 02:37:07 Eric Paris wrote:
> When an fanotify listener is closing it may cause a deadlock between the
> listener and the original task doing an fs operation.  If the original task
> is waiting for a permissions response it will be holding the srcu lock. 
> The listener cannot clean up and exit until after that srcu lock is
> syncronized. Thus deadlock.  The fix introduced here is to stop accepting
> new permissions events when a listener is shutting down and to grant
> permission for all outstanding events.  Thus the original task will
> eventually release the srcu lock and the listener can complete shutdown.

This seems to work now.

The one remaining issue is that processes blocked on perm events cannot be 
killed even with SIGKILL.  I don't know how hard it will be to fix this.

Thanks,
Andreas
