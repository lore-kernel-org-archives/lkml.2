Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0L3JYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 04:24:24 -0500
Received: from mx2.parallels.com ([64.131.90.16]:58056 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab0L3JYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 04:24:22 -0500
X-Greylist: delayed 838 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2010 04:24:22 EST
Message-ID: <4D1C4C7C.6050606@parallels.com>
Date: Thu, 30 Dec 2010 03:10:20 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kas@openvz.org>
CC: Rob Landley <rob@landley.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, <linux-nfs@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/12] make rpc_pipefs be mountable multiple time
References: <1293628470-28386-1-git-send-email-kas@openvz.org> <AANLkTi=AXz21wDeE1vPVD-6cEtj6faXN9x09eHDCsTkB@mail.gmail.com> <20101230085139.GA29697@shutemov.name>
In-Reply-To: <20101230085139.GA29697@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 02:51 AM, Kirill A. Shutemov wrote:
> On Wed, Dec 29, 2010 at 08:13:50PM -0600, Rob Landley wrote:
>> On Wed, Dec 29, 2010 at 7:14 AM, Kirill A. Shutemov<kas@openvz.org>  wrote:
>>>
>>> Prepare nfs/sunrpc stack to use multiple instances of rpc_pipefs.
>>> Only for client for now.
>>
>> What would a test case for this look like?  (Is there some way to tell
>> an nfs mount to use a specific instance of rpc_pipefs or something?)
>
> You can create a new instance of rpc_pipefs using 'newinstance'
> mountoption.
>
> Then you can specify which rpc_pipefs to use with 'rpcmount' mountoption
> of nfs mount. If none specifed, '/var/lib/nfs/rpc_pipefs' uses by default.

That path is as the process performing the mount sees it?

> If no rpcmount mountoption, no rpc_pipefs was found at
> '/var/lib/nfs/rpc_pipefs' and we are in init's mount namespace, we use
> init_rpc_pipefs.

It's the "we are in init's mount namespace" that I was wondering about.

So if I naievely chroot, nfs mount stops working the way it did before I 
chrooted unless I do an extra setup step?

I'm actually poking at getting nfs mount working in LXC containers with 
different network routing (mostly study so far, it took me a couple 
weeks just to get lxc to work for me and now I'm trying to wrap my head 
around Linux's NFS implementation), so I'm very interested in this...

Rob
