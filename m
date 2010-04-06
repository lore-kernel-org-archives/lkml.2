Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0DFRD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:03:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0DFRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:03:50 -0400
Message-ID: <4BBB61AF.6000608@redhat.com>
Date: Tue, 06 Apr 2010 19:30:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Dmitry Torokhov <dtor@vmware.com>,
       linux-kernel@vger.kernel.org, pv-drivers@vmware.com,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>	<20100405142419.2c9bea3d.akpm@linux-foundation.org>	<4BBA5E1C.10706@goop.org>	<20100405151720.8a6ac5e3.akpm@linux-foundation.org>	<4BBA7226.9080508@goop.org> <20100405163458.135fa319.akpm@linux-foundation.org>
In-Reply-To: <20100405163458.135fa319.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 02:34 AM, Andrew Morton wrote:
> On Mon, 05 Apr 2010 16:28:38 -0700
> Jeremy Fitzhardinge<jeremy@goop.org>  wrote:
>
>    
>> And is there some way to get the vm subsystem to provide backpressure:
>> "I'm getting desperately short of memory!"?
>>      
> Not really.  One could presumably pull dopey tricks by hooking into
> slab shrinker registration or even ->writepage().  But cooking up
> something explicit doesn't sound too hard - the trickiest bit would be
> actually defining what it should do.
>    

The oft-suggested approach is to look at the I/O load from guests and 
give more memory to those that are thrashing.  Of course not all I/O is 
directly due to memory pressure.

-- 
error compiling committee.c: too many arguments to function

