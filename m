Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1APXMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:12:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab1APXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:12:18 -0500
MIME-Version: 1.0
In-Reply-To: <20110117000659.57352da7@stein>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
 <20110116141105.59e5b3a2@stein> <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
 <20110117000659.57352da7@stein>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 15:11:57 -0800
Message-ID: <AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 3:06 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> I for one think that layered "select" directives will open too many cans
> of worms.
>
> Best don't use select at all.

That really doesn't work.

The reason everybody wants "select", and "depends on" is near useless,
is that from a usability perspective, it's totally unacceptable to say
"you need to know to enable that random other totally conceptually
unrelated config option".

Why the hell should a OCFS2 user have to know that he needs to enable
configfs to be able to enable ocfs2?

The thing is, we should do exactly the reverse of what you say, and
work towards the goal of "depends on" going away. Right now, the main
reason to use "depends on" is actually just that our Kconfig solvers
are stupid, and don't generally handle "select" very well. But that's
hopefully getting fixed.

                   Linus
