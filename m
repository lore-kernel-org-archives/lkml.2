Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab0DKRUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:20:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab0DKRUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:20:34 -0400
Date: Sun, 11 Apr 2010 19:20:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, linux-btrfs@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tytso@mit.edu, npiggin@suse.de, mingo@elte.hu,
       Ruald Andreae <ruald.a@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Olly Betts <olly@survex.com>, martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100411172007.GA11514@basil.fritz.box>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com> <4baeaee5.c5c2f10a.7187.2688@mx.google.com> <20100327204233.0d84542a@infradead.org> <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com> <87y6hcyu85.fsf@basil.nowhere.org> <4bbf401e.a3b9e70a.13f3.4460@mx.google.com> <4BC1E4A4.1070103@redhat.com> <4bc1fa59.c5c2f10a.776d.ffffcd91@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bc1fa59.c5c2f10a.776d.ffffcd91@mx.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Has the reason for this been identified? Judging from the nature of metadata
> loads, it would seem that it should be substantially easier to implement
> fsync() efficiently.

By design a copy on write tree fs would need to flush a whole
tree hierarchy on a sync. btrfs avoids this by using a special
log for fsync, but that causes more overhead if you have that
log on the same disk.  So IO subsystem will do more work.

It's a bit like JBD data journaling.

However it should not have the stalls inherent in ext3's journaling.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
