Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0GIArq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791Ab0GIAro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:47:44 -0400
Date: Thu, 8 Jul 2010 20:49:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Hendry" <andrew.hendry@gmail.com>
Subject: Re: [Bug #16306] 2.6.35-rc3 BUG: unable to handle kernel NULL
 pointer dereference at 0000000000000048 cifs_show_options
Message-ID: <20100708204945.01ca1236@corrin.poochiereds.net>
In-Reply-To: <TXb9XdQzJoD.A.DhB.SMmNMB@chimera>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
	<TXb9XdQzJoD.A.DhB.SMmNMB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Jul 2010 01:41:39 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16306
> Subject		: 2.6.35-rc3 BUG: unable to handle kernel NULL pointer dereference at 0000000000000048 cifs_show_options
> Submitter	: Andrew Hendry <andrew.hendry@gmail.com>
> Date		: 2010-06-26 10:46 (13 days old)
> Message-ID	: <AANLkTilhTrEBYZd4HxeXQk8B6-yV8rCJ2C0jXsEREgIR@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127754922110501&w=2
> Handled-By	: Jeff Layton <jlayton@redhat.com>
> 
> 

Not sure if this is a new bug or not...

I don't think this is really a CIFS bug, per-se. It seems like the
problem may be that the iterator for /proc/pid/mountinfo is not
sufficiently protected against removal from the vfsmount list.

Filesystems don't seem to be expected to do any locking in their
show_options routines though so I'm guessing that something is borked
in the generic vfs layer.

Either that or this is some sort of generic mem corruption? I'm open to
input from others that have a better grasp of this stuff at the VFS
layer...

-- 
Jeff Layton <jlayton@redhat.com>
