Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1GNWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab1GNWOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:14:47 -0400
Message-ID: <4E1F6A51.3020807@redhat.com>
Date: Thu, 14 Jul 2011 18:14:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Rik van Riel <riel@redhat.com>
Subject: Re: 3.0.0-rc6 ~9X system time degradation on kernbench
References: <4E175C45.1060700@redhat.com> <4E17A4BF.5050500@redhat.com> <20110709224803.GC9545@bombadil.infradead.org>
In-Reply-To: <20110709224803.GC9545@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/09/2011 06:48 PM, Kyle McMartin wrote:
> On Fri, Jul 08, 2011 at 08:45:51PM -0400, Rik van Riel wrote:
>   
>> On 07/08/2011 03:36 PM, Prarit Bhargava wrote:
>>     
>>> Just some numbers out of kernbench.  System Time&  Context Switches
>>> climb dramatically between 2.6.38 and 3.0.0-rc6.  Currently bisecting to
>>> find out why.  .config is based on Fedora's x86_64 .config.
>>>       
>>     
> Er, if you're using Fedora's config, did you 'make release' first?
> grep DEBUG in the config and see why... ;-)
>   

That did it :)

 
Thu Jul 14 15:33:27 EDT 2011
3.0.0-rc7+
Average Optimal load -j 48 Run (std deviation):
Elapsed Time 178.384 (0.618692)
User Time 3970.09 (1.93208)
System Time 587.498 (0.511488)
Percent CPU 2554.2 (8.58487)
Context Switches 1.08771e+06 (9697.64)
Sleeps 871265 (13137.6)

Thu Jul 14 16:06:39 EDT 2011
2.6.38.8-35.fc15.x86_64
Average Optimal load -j 48 Run (std deviation):
Elapsed Time 184.6 (8.64522)
User Time 3961.07 (5.05)
System Time 637.382 (11.7187)
Percent CPU 2494.4 (102.827)
Context Switches 1.09046e+06 (3986.03)
Sleeps 873607 (4756.41)

Still a bit higher ... but not 9x ... thanks Kyle.

P.


