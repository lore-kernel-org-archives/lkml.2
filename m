Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab1I2U6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:58:49 -0400
Received: from cobra.newdream.net ([66.33.216.30]:41211 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab1I2U6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=PAqg9ltlcUn82LWB8QUTESe7D7FlLTsqJNKCJoebW8JLT1/t
	h6GNl5gTUF97VqOlJJSIq4jZrKrSskqJGh82a3bSenZBpjvoc63NIDvSICdnl/I+
	V4T3CWVQVV8g2i9XE5aHxAY/dKI9CP5GMJTqN0SECR0ijfdQfn30G8JLQFc=
Date: Thu, 29 Sep 2011 13:58:47 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.1
Message-ID: <Pine.LNX.4.64.1109291355530.13653@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://github.com/NewDreamNetwork/ceph-client.git for-linus

There are a few small fixes here (avoid unnecessary socket reconnects, 
small memory leak), and some more critical fixes with OSD request 
requeuing.  One bug fixes a crash that is reliably reproduced by cycling 
an OSD under a mapped RBD device, and the last two fix bugs in the 
tracking of temporary data location mappings.

Thanks!
sage


Jim Schutt (1):
      libceph: initialize ack_stamp to avoid unnecessary connection reset

Noah Watkins (1):
      libceph: fix parse options memory leak

Sage Weil (3):
      libceph: fix linger request requeuing
      libceph: fix pg_temp mapping calculation
      libceph: fix pg_temp mapping update

 net/ceph/ceph_common.c |    1 +
 net/ceph/messenger.c   |    1 +
 net/ceph/osd_client.c  |    4 +--
 net/ceph/osdmap.c      |   84 +++++++++++++++++++++++++----------------------
 4 files changed, 48 insertions(+), 42 deletions(-)
