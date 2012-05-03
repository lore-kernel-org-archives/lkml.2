Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2ECOME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:12:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38258 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2ECOMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:12:02 -0400
Date: Thu, 3 May 2012 15:11:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: mtk.manpages@gmail.com, Mike Frysinger <vapier@gentoo.org>,
        linux-man@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] open(2): document O_PATH
Message-ID: <20120503141156.GP6871@ZenIV.linux.org.uk>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
 <877gwxacti.fsf@skywalker.in.ibm.com>
 <CAKgNAkiRH8p=Dp1tqkb3D9oRVCOSnj2bofgFN5x2svntN7vtPg@mail.gmail.com>
 <87bom5xswc.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bom5xswc.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 07:34:35PM +0530, Aneesh Kumar K.V wrote:

> I looked at dnotify_flush, they remove markers on an inode.
> But then it also checks for filp to match. So I am not sure
> whether skipping dnotify_flush for O_PATH descriptor have any impact. We
> can't use O_PATH descriptor for dnotify fcntl any way. So in
> dnotify_flush we will not match the filp.
> 
> Viro,
> 
> Any reason why we skip dnotify_flush  ?

See your last sentence above - why bother finding the mark, scanning the
list, etc. when we know that there won't be any matches?
