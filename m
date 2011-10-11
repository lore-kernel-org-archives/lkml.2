Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1JKVIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:08:06 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18956 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1JKVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:07:46 -0400
Message-ID: <4E94B01D.2050402@cavium.com>
Date: Tue, 11 Oct 2011 14:07:41 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
References: <20110922184614.25419.84606.stgit@ponder> <20111011134753.2751aeb1.akpm@linux-foundation.org>
In-Reply-To: <20111011134753.2751aeb1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2011 21:07:44.0416 (UTC) FILETIME=[D208CA00:01CC8859]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 01:47 PM, Andrew Morton wrote:
> On Thu, 22 Sep 2011 12:51:23 -0600
> Grant Likely<grant.likely@secretlab.ca>  wrote:
>
>> Allow drivers to report at probe time that they cannot get all the resources
>> required by the device, and should be retried at a later time.
>>
>> This should completely solve the problem of getting devices
>> initialized in the right order.  Right now this is mostly handled by
>> mucking about with initcall ordering which is a complete hack, and
>> doesn't even remotely handle the case where device drivers are in
>> modules.  This approach completely sidesteps the issues by allowing
>> driver registration to occur in any order, and any driver can request
>> to be retried after a few more other drivers get probed.
>
> What happens is there is a circular dependency, or if a driver's
> preconditions are never met?  AFAICT the code keeps running the probe
> function for ever.
>

The deferred probe functions are only run once per (other) driver 
binding event.  So once you quit registering new drivers, no further 
probing is done.  There is no endless loop happening here.

If the preconditions are never met, the driver will just sit in the list 
waiting.


> If so: bad.  The kernel should detect such situations, should
> exhaustively report them and if possible, fix them up and struggle
> onwards.
>

I don't think we should actively report anything, but being able to 
inspect the deferred probe list from user space might be useful for 
diagnosing problems


David Daney

