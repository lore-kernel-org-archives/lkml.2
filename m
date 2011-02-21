Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1BUV3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:29:25 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60471 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab1BUV3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:29:23 -0500
Message-ID: <4D62D930.8060304@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 16:29:20 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com> <4D629427.8020500@gmail.com> <4D629D03.90801@linux.vnet.ibm.com> <4D62CD93.3040206@gmail.com>
In-Reply-To: <4D62CD93.3040206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 03:39 PM, Jiri Slaby wrote:
> On 02/21/2011 06:12 PM, Rajiv Andrade wrote:
>> On 02/21/2011 01:34 PM, Jiri Slaby wrote:
>>> There has to be another problem which caused my regression. And since it
>>> reports "Operation Timed out", the former default timeout values worked
>>> for me, the ones read from TPM do not.
>> Yes, it's highly due inconsistent timeout values reported by the TPM as
>> I mentioned, my working timeouts are:
>> 3020000 4510000 181000000
> 1000000 2000 150000
>
> Actually the first one from HW is 1. This is one is HZ after correction
> in get_timeout. So perhaps it is in ms, yes.

Following the specs, the timeouts are supposed to be in microseconds and 
ascending order for short, medium and long duration. Of course, if the 
device returns wrong timeouts, the command isn't going to succeed, 
failing the suspend in this case. Nevertheless, I think we need the 
patch I put in but at the same time we'll need a work-around for devices 
like this. There was one person stating that this patch fixed are 
problem on his machine. Can you find the 'caps' entry in /sys 
(/sys/devices/pnp0/00:06) and let us know its content?

Thanks and regards,
     Stefan

