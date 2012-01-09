Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2AIPtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:49:52 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:57019 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2AIPtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:49:50 -0500
X-AuditID: c1b4fb39-b7b3eae00000252a-b7-4f0b0c9ca763
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: lenb@kernel.org, ying.huang@intel.com, akpm@linux-foundation.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] Allow empty Trigger Error Action Table 
Date: Mon, 9 Jan 2012 16:49:43 +0100
Message-ID: <1326124184-10084-1-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When troubleshooting some BIOS code I encounter strange errors about firmware bugs. On closer inspection I found that the Trigger table returned from the firmware was empty but the header looked OK:

header_size = 16
table_size = 16
entry_count = 0

When looking at einj.c I found that this header would result in the error I was receiving. I took a quick look at the docs and from what I can tell this is a valid header, yes?

I don't know much about ACPI so I might be way off but the attached patch fix the error message for me (however I still can't detect the injected error but that might depend on my detection code or buggy firmware...)

Thanks
// Niklas

