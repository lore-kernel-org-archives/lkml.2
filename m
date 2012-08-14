Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2HNDAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 23:00:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:28385 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab2HNDAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 23:00:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,763,1336374000"; 
   d="scan'208";a="180665972"
Message-ID: <5029BF49.6090202@intel.com>
Date: Mon, 13 Aug 2012 20:00:25 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: nhorman@tuxdriver.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v1 2/2] net: netprio: fd passed in SCM_RIGHTS datagram
 not set correctly
References: <20120814013939.3144.13167.stgit@jf-dev1-dcblab> <20120814013944.3144.53854.stgit@jf-dev1-dcblab> <20120814023128.GG23464@ZenIV.linux.org.uk>
In-Reply-To: <20120814023128.GG23464@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2012 7:31 PM, Al Viro wrote:
> On Mon, Aug 13, 2012 at 06:39:45PM -0700, John Fastabend wrote:
>>   		/* Bump the usage count and install the file. */
>>   		get_file(fp[i]);
>>   		fd_install(new_fd, fp[i]);
>> +		sock = sock_from_file(fp[i], &err);
>> +		if (sock)
>> +			sock->sk->sk_cgrp_prioidx = prioidx;
>
> Better to do that before fd_install() exposes the sucker; it's not
> a serious issue, but it's more obviously correct that way.
>

Right. Moved it in v2.
