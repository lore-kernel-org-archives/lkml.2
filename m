Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2JBWtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:49:00 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:44942 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2JBWs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:48:59 -0400
Message-ID: <506B6F59.8060800@hp.com>
Date: Tue, 02 Oct 2012 15:48:57 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Jones <rick.jones2@hp.com>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in ttwu_queue()
References: <20121002065143.GK29125@suse.de> <1349164176.7086.43.camel@marge.simpson.net> <20121002084501.GL29125@suse.de>
In-Reply-To: <20121002084501.GL29125@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 01:45 AM, Mel Gorman wrote:

> SIZE=64
> taskset -c 0 netserver
> taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE

Just FYI, unless you are running a hacked version of netperf, the "50" 
in "-i 50,6" will be silently truncated to 30.

happy benchmarking,

rick jones

PS - I trust it is the receive-side throughput being reported/used with 
UDP_STREAM :)
