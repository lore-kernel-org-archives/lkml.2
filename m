Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1CQNlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:41:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21857 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1CQNlG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 17 Mar 2011 09:41:06 -0400
Date: Thu, 17 Mar 2011 09:40:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: rshriram@cs.ubc.ca, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        wkenji@jp.fujitsu.com, kaz@jp.fujitsu.com, rjw@sisk.pl
Subject: [GIT PULL] (xen) stable/xen.pm.bug-fixes for 2.6.39
Message-ID: <20110317134039.GB6120@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D820F5C.0108,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

This should be the last git pull for 2.6.39 for the Xen components
(barring bug-fixes naturally).

Please pull

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/xen.pm.bug-fixes


#stable/xen.pm.bug-fixes is based off 76ca07832842100b14a31ad8996dab7b0c28aa42
"Merge branch 'for-linus' of git://xenbits.xen.org/people/sstabellini/linux-pvhvm"

The reason behind basing this branch on this specific git commit is that these patches
depend on the fixes provided by Stefano's linux-pvhvm.

The patches in this branch were posted and Ack-ed some time earlier but had this
complicated dependency chart (Rafeal's, mine and Stefano's were all involved) and
we simplified it just now by jettisoning some of those patches. Will revisit those
that we jettisoned in 2.6.40 time-frame.

Anyhow these two patches fix a bug where checkpoint-ing would utterly fail
and they do that by swapping over to use the Hibernate API instead of the older
PM sleep API, which just meant using a new set of  arguments for the thaw/unfreeze/
resume/suspend/etc calls.

The diffstat:

 drivers/xen/manage.c                       |   16 ++++++++--------
 drivers/xen/xenbus/xenbus_probe.c          |   12 ++++++++++--
 drivers/xen/xenbus/xenbus_probe.h          |    3 ++-
 drivers/xen/xenbus/xenbus_probe_frontend.c |   11 +++++++++--
 include/xen/xenbus.h                       |    2 +-
 5 files changed, 30 insertions(+), 14 deletions(-)


Kazuhiro SUZUKI (1):
      xen: xenbus PM events support

Shriram Rajagopalan (1):
      xen: use freeze/restore/thaw PM events for suspend/resume/chkpt

