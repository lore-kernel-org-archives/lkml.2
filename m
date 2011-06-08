Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1FHHq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:46:58 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:34794 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1FHHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:46:55 -0400
Message-Id: <20110608074523.211912903@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 08 Jun 2011 09:45:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>
Subject: [patch 0/1] [RFC] include storage keys in hibernation image
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

we have discovered a shortcoming of the s390 support for supend to disk.
The problem is that we currently do not save and restore the storage
keys - the one additional byte associated with each 4K page, a unique
property of s390. The resume from disk will read the hibernation image
from disk and restore the original pages. The I/O or the memory move for
safe pages will set the referenced and the dirty bit in the storage key
for every restored page. Without a reset to the state before the
hibernation cycle the pages will appear to be dirty which causes
problems for e.g. read-only filesystems. 

The solution implemented with this patch saves the storage key in the
upper 8 bits of the page-frame-numbers. The code adds 6 new function
in kernel/power/snapshot.c which are conditionally defined with
CONFIG_S390. The call sites of these functions are scattered in the
snapshot code which makes it hard to find a better abstraction for the
interface. The comments should make clear what the functions do.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
