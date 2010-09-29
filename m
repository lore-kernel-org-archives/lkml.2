Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0I2TVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:21:37 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8816 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0I2TVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:21:36 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC4vo0yrRN+K/2dsb2JhbACiHHGrRZxohUQEhFCFaoR5
X-IronPort-AV: E=Sophos;i="4.57,255,1283731200"; 
   d="scan'208";a="596712936"
From: Roland Dreier <rdreier@cisco.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int>
	<adawrq431sr.fsf@cisco.com> <201009292117.54828.arnd@arndb.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Sep 2010 12:21:14 -0700
In-Reply-To: <201009292117.54828.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 29 Sep 2010 21:17:54 +0200")
Message-ID: <ada4od82w5x.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The main difference between default_llseek and generic_file_llseek
 > is that default_llseek doesn't care about the maximum file size
 > of the underlying file system, which is ULONG_MAX on debugfs,
 > so they are equivalent.

I thought default_llseek also takes the BKL still?

 > In general, the preferred one is no_llseek for those files where
 > you know you do not need to seek. If you do, I'd use default_llseek
 > for character devices and generic_file_llseek for file systems
 > that set the s_maxbytes.

The case in question is for debugfs files, so we should use
generic_file_llseek, right?

 - R.
