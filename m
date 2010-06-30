Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0F3RJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:09:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23694 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab0F3RJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 13:09:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:
	content-transfer-encoding:x-system-of-record;
	b=Rxi3jCkZjIKOZE+DQAOtXp4zrq+Me5itWVUsGR1GDDZ89DzvA3MtZoq4Z9YWiJwiR
	Gg/8yI4ni+bPukOwBoRTA==
Subject: Re: [patch 00/52] vfs scalability patches updated
From: Frank Mayhar <fmayhar@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20100630113054.GL24712@dastard>
References: <20100624030212.676457061@suse.de>
	 <20100630113054.GL24712@dastard>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 30 Jun 2010 10:08:54 -0700
Message-Id: <1277917734.4624.26.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 21:30 +1000, Dave Chinner wrote:
> Sure, but I have to question how much of this is actually necessary?
> A lot of it looks like scalability for scalabilities sake, not
> because there is a demonstrated need...

Well, we've repeatedly run into problems with contention on the
dcache_lock as well as the inode_lock; changes that improve those paths
are extremely interesting to us.  I've also seen numbers from systems
with large (i.e. 32 to 64) numbers of cores that clearly show serious
problems in this area.

Further, while this seems like a bunch of patches, a close look shows
that it basically just pushes the dcache and inode locks down as far as
possible, making other improvements (such as removal of a few atomics
and no longer batching inode reclaims, among other things) based on that
work.  I would be hard-pressed to find much to cherry-pick from this
patch set.

One interesting thing might be to do a set of performance tests for
kernels with increasingly more of the patchset, just to see the effect
of the earlier patches against a vanilla kernel and to measure the
cumulative effect of the later patches.  (I'm not volunteering, however:
ENOTIME.)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

