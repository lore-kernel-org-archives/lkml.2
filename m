Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2HMGYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 02:24:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:57949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2HMGYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 02:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,758,1336374000"; 
   d="scan'208";a="207426650"
Message-ID: <50289D7F.3070402@intel.com>
Date: Sun, 12 Aug 2012 23:23:59 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [flame^Wreview] net: netprio_cgroup: rework update socket logic
References: <20120813015348.GZ23464@ZenIV.linux.org.uk> <502896C5.7080303@intel.com>
In-Reply-To: <502896C5.7080303@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK clearly I screwed it up thanks for reviewing Al. How about this.
>
>                  fdt = files_fdtable(files);
>                  for (fd = 0; fd < fdt->max_fds; fd++) {
>                          struct socket *sock;
>                          int err = 0;
>
>                          sock = sockfd_lookup(fd, &err);
>                          if (!sock) {
typo                           ^^^^^^
			   if (sock) {

to be honest I can't see why I didn't use sockfd_lookup in the first
place...
