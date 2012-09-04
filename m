Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab2IDV2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:28:15 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:44373
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757793Ab2IDV2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:28:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 00/10] Tools: hv: kvp
Date: Tue,  4 Sep 2012 14:45:56 -0700
Message-Id: <1346795156-25614-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resubmission of the subset of the patches that were not
accepted in an earlier submission. The main objection last time was
that the KVP daemon code invoked external scripts for some of the
operations and that I had not included those scripts in the patchset.
This current approach of not encumbering the KVP daemon code with
Distro specific details was discussed on this mailing list and here is
the summary:

1) Using Network Manager APIs in the KVP daemon code directly would
minimize environments where KVP functionality could be deployed since
Network Manager is not available in all of the Distro images of interest;
especially server images.

2) The current architecture of invoking external scripts for what is
essentially a distro specific operation retains full flexibility of
deploying KVP on all Distros of interest while not sacrificing our ability to
use Network Manager APIs. For instance a Distro could choose to implement these
external scripts using NM AMPIs.

In this patchset I have included the external scripts that I had used to test the
KVP functionality as example scripts. These are meant as just examples.


K. Y. Srinivasan (10):
  Tools: hv: Get rid of some unused variables
  Tools: hv: Correctly type string variables
  Tools: hv: Add an example script to retrieve DNS entries
  Tools: hv: Gather DNS information
  Tools: hv: Add an example script to retrieve dhcp state
  Tools: hv: Gather DHCP information
  Tools: hv: Add an example script to configure an interface
  Tools: hv: Implement the KVP verb - KVP_OP_SET_IP_INFO
  Tools: hv: Rename the function kvp_get_ip_address()
  Tools: hv: Implement the KVP verb - KVP_OP_GET_IP_INFO

 include/linux/hyperv.h       |    2 +
 tools/hv/hv_get_dhcp_info.sh |   25 ++
 tools/hv/hv_get_dns_info.sh  |   13 +
 tools/hv/hv_kvp_daemon.c     |  607 +++++++++++++++++++++++++++++++++++++++++-
 tools/hv/hv_set_ifconfig.sh  |   68 +++++
 5 files changed, 703 insertions(+), 12 deletions(-)
 create mode 100755 tools/hv/hv_get_dhcp_info.sh
 create mode 100755 tools/hv/hv_get_dns_info.sh
 create mode 100755 tools/hv/hv_set_ifconfig.sh

-- 
1.7.4.1

