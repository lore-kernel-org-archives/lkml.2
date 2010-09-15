Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0IOMs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:48:27 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44497 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0IOMs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:48:26 -0400
Message-ID: <4C90C098.6070404@kernel.dk>
Date: Wed, 15 Sep 2010 14:48:24 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add assert_spin_locked() to ensure lock is held
References: <1284554007-13077-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1284554007-13077-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-15 14:33, Namhyung Kim wrote:
> Use assert_spin_locked() macro in order to ensure that queue_lock
> must be held prior to calling some EXPORTed functions.

As far as I know, no such bug has ever occurred that I know
of. So while I don't mind adding such instrumentation, there's
little point to doing it when you are not seeing any usability
problems in there. And all these paths (requeue less) are
heavily used, so problems would appear quickly.

Locking in the block layer is still fairly trivial, we just
have the one lock per queue.

-- 
Jens Axboe

