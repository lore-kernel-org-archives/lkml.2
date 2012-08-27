Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2H0VoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:44:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38640 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab2H0VoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:44:13 -0400
Message-ID: <503BE96E.3000205@parallels.com>
Date: Mon, 27 Aug 2012 14:41:02 -0700
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: <mjw@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <peterz@infradead.org>, <mtosatti@redhat.com>,
        <mingo@redhat.com>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
References: <20120823231346.11681.1502.stgit@lambeau>  <503BC298.3080306@redhat.com> <1346098984.8623.23.camel@lambeau>  <503BD920.20603@redhat.com> <1346102820.8623.32.camel@lambeau>
In-Reply-To: <1346102820.8623.32.camel@lambeau>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [38.96.16.75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 02:27 PM, Michael Wolf wrote:
> On Mon, 2012-08-27 at 13:31 -0700, Avi Kivity wrote:
>> On 08/27/2012 01:23 PM, Michael Wolf wrote:
>>>>
>>>> How would a guest know what its entitlement is?
>>>>
>>>>
>>>
>>> Currently the Admin/management tool setting up the guests will put it on
>>> the qemu commandline.  From this it is passed via an ioctl to the host.
>>> The guest will get the value from the host via a hypercall.
>>>
>>> In the future the host could try and do some of it automatically in some
>>> cases. 
>>
>> Seems to me it's a meaningless value for the guest.  Suppose it is
>> migrated to a host that is more powerful, and as a result its relative
>> entitlement is reduced.  The value needs to be adjusted.
> 
> This is why I chose to manage the value from the sysctl interface rather
> than just have it stored as a value in /proc.  Whatever tool was used to
> migrate the vm could hopefully adjust the sysctl value on the guest.
>>
>> This is best taken care of from the host side.
> 
> Not sure what you are getting at here.  If you are running in a cloud
> environment, you purchase a VM with the understanding that you are
> getting certain resources.  As this type of user I don't believe you
> have any access to the host to see this type of information.  So the
> user still wouldnt have a way to confirm that they are receiving what
> they should be in the way of processor resources.
> 
> Would you please elaborate a little more on this?

What do you mean they have no access to the host?
They have access to all sorts of tools that display information from the
host. Speaking of a view-only resource, those are strictly equivalent.



