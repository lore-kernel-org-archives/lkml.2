Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1C2VbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:31:00 -0400
Received: from cobra.newdream.net ([66.33.216.30]:40884 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1C2Va7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=ICDePaRKEecBmItyN2xfhi0R582PAhkpATGJuxPI9BK0SCL/
	DzlVH6qEwoYWR1eCrNINWRzptg96nKLd2+8pipeNVR7aZeD63cA4IzxqRcxM5qP2
	E0wPYfbPwrImdpRUkdbU38Y0Xl0XllH2pccbOzLMbeKdWlgl8mUE7gEjYYM=
Date: Tue, 29 Mar 2011 14:33:56 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates pt 2
Message-ID: <Pine.LNX.4.64.1103291426070.22956@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this second set of Ceph updates/fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git master

The main thing is a patchset to use the keys api to pass the security key 
from mount.ceph to the client.  There are also a few bug fixes that have 
come in over the past week.

Thanks!
sage


Dan Carpenter (1):
      ceph: unlock on error in ceph_osdc_start_request()

Mariusz Kozlowski (1):
      ceph: fix possible NULL pointer dereference

Sage Weil (2):
      ceph: flush msgr_wq during mds_client shutdown
      libceph: fix null dereference when unregistering linger requests

Tommi Virtanen (3):
      ceph: Move secret key parsing earlier.
      libceph: Get secret from the kernel keys api when mounting with key=NAME.
      libceph: Create a new key type "ceph".

 fs/ceph/mds_client.c         |    6 ++
 fs/ceph/super.c              |    2 +-
 include/keys/ceph-type.h     |    8 +++
 include/linux/ceph/auth.h    |    4 +-
 include/linux/ceph/libceph.h |    2 +-
 net/ceph/Kconfig             |    1 +
 net/ceph/auth.c              |    8 ++--
 net/ceph/auth_x.c            |    8 ++-
 net/ceph/ceph_common.c       |  112 ++++++++++++++++++++++++++++++++++++++----
 net/ceph/crypto.c            |   73 +++++++++++++++++++++++++++
 net/ceph/crypto.h            |    4 ++
 net/ceph/mon_client.c        |    2 +-
 net/ceph/osd_client.c        |   12 +++--
 13 files changed, 215 insertions(+), 27 deletions(-)
 create mode 100644 include/keys/ceph-type.h
