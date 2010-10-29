Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484Ab0J2Nw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab0J2Nw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:52:56 -0400
Subject: Re: Ensure FMODE_NONOTIFY is not set by userspace
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101029100217.GC26242@lsanfilippo.unix.rd.tt.avira.com>
References: <20101029100217.GC26242@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 09:52:50 -0400
Message-ID: <1288360370.3017.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 12:02 +0200, Lino Sanfilippo wrote:
> In fsnotify_open() ensure that FMODE_NONOTIFY is never set by userspace.
>     Also always call fsnotify_parent and fsnotify.

Did you find a place where the user was able to set FMODE_NONOTIFY?
That would be a problem.  But that's not what is happening here and
that's not what you are fixing.

This is a test if FMODE_NONOTIFY was already set then we do not send
notification about that file.  The current code is correct and your
patch breaks it....

-Eric

