Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1ATJKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:10:03 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44126 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1ATJJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:09:59 -0500
Message-ID: <4D37FBE1.7010704@linux.vnet.ibm.com>
Date: Thu, 20 Jan 2011 14:39:53 +0530
From: Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        vatsa@linux.vnet.ibm.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 0/0] Panic on softdog timeout
References: <4D358B34.7040902@linux.vnet.ibm.com> <20110118155212.GB17710@hack>
In-Reply-To: <20110118155212.GB17710@hack>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 09:22 PM, Américo Wang wrote:
> On Tue, Jan 18, 2011 at 06:14:36PM +0530, Anithra P Janakiraman wrote:
>>
>> Hi.
>>
>> We currently have no way of determining the reason for failure when a
>> softdog timeout occurs. At the minimum a snapshot of the system would
>> help to determine the cause.
>> The attached patch invokes panic on softdog timeout iff kdump is
>> configured, if kdump is not configured it works as usual.
>>
>
> We don't do it in this way, check softlockup_panic, we have
> a boot parameter, i.e. "softlockup_panic=". :)


Some softdog specific scenarios cannot be handled by a softlockup 
detector. We use softdog to watch for critical application failures, 
where it is possible that the application has failed but there isn't a 
softlockup as such.
For e.g. when doing high availability tests on applications, softdog is 
setup so that the timer is reset by an application thread. In case of 
the application failing the timer expires and causes a reboot. In such 
scenarios some information on what caused the  failure would be useful 
and i don't see how softlockup can be used. The patch i had sent would 
be useful in these cases. If I am missing something please do let me know.
I will make the modifications as suggested by Dave Hansen and post the 
patch shortly.

Anithra.


