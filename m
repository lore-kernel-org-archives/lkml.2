Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3AJSmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:42:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29887 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3AJSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:42:07 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-4f-50ef0b7c6cf0
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCHv2] Smack: add support for modification of existing rules
Date: Thu, 10 Jan 2013 19:41:59 +0100
Message-id: <1357843320-11883-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOJMWRmVeSWpSXmKPExsVy+t/xy7o13O8DDG4cVrRY2LaExeLyrjls
	Fh96HrE5MHt83iQXwBjFZZOSmpNZllqkb5fAlXH302HmggNsFS+f7GJuYFzK2sXIySEhYCKx
	+dx0ZghbTOLCvfVsXYxcHEICSxkl1j87yQ7h9DFJnHpwHayKTUBdYun8XjYQW0RAR2Lfnudg
	RcwC7YwSc48+YQFJCAt4SHydeBxsBYuAqsSN+d/AGngFnCVWzmpkg1inKNH9bALbBEbuBYwM
	qxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCPPt1B+PSY1aHGAU4GJV4eDV93wUIsSaWFVfm
	HmKU4GBWEuFtWQAU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwDj7bvLP2bnijut9kuccamR3VSxd
	nH3z5U2XebmPVVvjqxf/OtWbcPbD94W6E29meV4RLstMfvLbMeSJsundhPkLDNk+TTtzeckk
	o+r4/Vt3nPtWX/ixeHJDZMX7+6tkv2lzGrIkuwYJXuTTSS9ZkM8/bclu/vXSJxqvvAxn+9HM
	FBP8yiNN77ISS3FGoqEWc1FxIgAxI8BvygEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch introduces in-place modification of Smack rules.
Until now Smack supported only overwriting of existing rules.
To change permitted access for a given subject and object, user had
to read list of rules to get current accesses, modify it and write
modified rule back to kernel. This way was inefficient, non-atomic
and unnecessarily difficult.
New interface is intended to ease such modifications.

Changes in v2:
- dropped patches for smackfs seq list operations
- changed modification approach to simple integer assignment

Rafal Krypa (1):
  Smack: add support for modification of existing rules

 Documentation/security/Smack.txt |   11 ++
 security/smack/smackfs.c         |  249 ++++++++++++++++++++++++++------------
 2 files changed, 181 insertions(+), 79 deletions(-)

-- 
1.7.10.4

