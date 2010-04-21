Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0DUUDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:03:44 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:35763 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0DUUDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:03:42 -0400
Message-id: <4BCF5A09.80404@acm.org>
Date: Wed, 21 Apr 2010 15:03:21 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: openipmi-developer@lists.sourceforge.net, bjorn.helgaas@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ipmi: Only register one si per bmc
References: <1271788828-10231-1-git-send-email-mjg@redhat.com>
 <1271788828-10231-2-git-send-email-mjg@redhat.com> <4BCF3F69.3050003@acm.org>
 <20100421182154.GA16436@srcf.ucam.org>
In-reply-to: <20100421182154.GA16436@srcf.ucam.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Wed, Apr 21, 2010 at 01:09:45PM -0500, Corey Minyard wrote:
>
>   
>> If I understand this correctly, this would really be "Only register one  
>> si per system".  Unfortunately, there are systems that have more than  
>> one BMC each with their own interface.
>>     
>
> The spec explicitly says that while a system may have multiple BMCs, 
> only one BMC may respond to GetDeviceID (6.11 of the 2.0 spec). Is the 
> real world irritatingly incompatible with this?
>   
That section is quite misleading.  There may be management controllers 
that are not BMCs, and they may have system interfaces.  There may only 
be on BMC in a system, though, per the spec.  That really has more to do 
with event handling and the main SDR repository, though.

However, IBM makes some systems that can plug together for scalability.  
Each individual system has a BMC, and when you plug them together into 
an SMP system, all the BMCs are still there.  At least that's how I 
understand it.  I'm not sure if the other BMCs become satellite MCs in 
that case, which would be legit, sort of.  So I guess the answer to you 
question would be: "Yes, the world is not compatible with the spec".

-corey
