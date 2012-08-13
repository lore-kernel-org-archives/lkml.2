Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2HMQ6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:58:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:3365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab2HMQ6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:58:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,761,1336374000"; 
   d="scan'208";a="185806320"
Message-ID: <50293224.90803@intel.com>
Date: Mon, 13 Aug 2012 09:58:12 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [flame^Wreview] net: netprio_cgroup: rework update socket logic
References: <20120813015348.GZ23464@ZenIV.linux.org.uk> <502896C5.7080303@intel.com> <50289D7F.3070402@intel.com> <20120813121827.GB23464@ZenIV.linux.org.uk>
In-Reply-To: <20120813121827.GB23464@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> HOWEVER, it still doesn't address more fundamental problem - somebody
> creating a socket and passing it to you in SCM_RIGHTS datagram will
> leave you with a socket you can do IO on, still tagged according to who
> had created it.
>
> AFAICS, the whole point of that exercise was to allow third-party changing
> the priorities of traffic on sockets already created by a process we now
> move to a different cgroup.  Consider e.g. this:

Correct that is the point of the exercise.

To fix this specific case we could add a call to sock_update_netprioidx
in scm_recv to set the sk_cgrp_prioidx value.
