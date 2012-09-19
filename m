Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2ISJu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:50:28 -0400
Received: from natasha.panasas.com ([67.152.220.90]:47708 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab2ISJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:50:24 -0400
Message-ID: <50599541.9080604@panasas.com>
Date: Wed, 19 Sep 2012 12:49:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Subject: Re: [ 16/46] NFSv4.1: Remove a bogus BUG_ON() in nfs4_layoutreturn_done
References: <20120912233817.662663809@linuxfoundation.org> <20120912233819.364182315@linuxfoundation.org> <1347813183.13258.286.camel@deadeye.wl.decadent.org.uk> <20120916163703.GA7871@kroah.com> <4FA345DA4F4AE44899BD2B03EEEC2FA908FC6732@SACEXCMBX04-PRD.hq.netapp.com>
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA908FC6732@SACEXCMBX04-PRD.hq.netapp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 04:05 PM, Myklebust, Trond wrote:

>> -----Original Message-----
>> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
>> Sent: Sunday, September 16, 2012 12:37 PM
>> To: Ben Hutchings
>> Cc: Myklebust, Trond; linux-kernel@vger.kernel.org;
>> stable@vger.kernel.org; Boaz Harrosh; Tigran Mkrtchyan
>> Subject: Re: [ 16/46] NFSv4.1: Remove a bogus BUG_ON() in
>> nfs4_layoutreturn_done
>>
>> On Sun, Sep 16, 2012 at 05:33:03PM +0100, Ben Hutchings wrote:
>>> On Wed, 2012-09-12 at 16:39 -0700, Greg Kroah-Hartman wrote:
>>>> From: Greg KH <gregkh@linuxfoundation.org>
>>>>
>>>> 3.0-stable review patch.  If anyone has any objections, please let me
>> know.
>>>>
>>>> ------------------
>>>>
>>>> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>>>>
>>>> commit 47fbf7976e0b7d9dcdd799e2a1baba19064d9631 upstream.
>>>>
>>>> Ever since commit 0a57cdac3f (NFSv4.1 send layoutreturn to fence
>>>> disconnected data server) we've been sending layoutreturn calls
>>>> while there is potentially still outstanding I/O to the data
>>>> servers. The reason we do this is to avoid races between replayed
>>>> writes to the MDS and the original writes to the DS.
>>>>
>>>> When this happens, the BUG_ON() in nfs4_layoutreturn_done can be
>>>> triggered because it assumes that we would never call layoutreturn
>>>> without knowing that all I/O to the DS is finished. The fix is to
>>>> remove the BUG_ON() now that the assumptions behind the test are
>>>> obsolete.
>>>>
>>>> Reported-by: Boaz Harrosh <bharrosh@panasas.com>
>>>> Reported-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
>>>> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> [...]
>>>
>>> The upstream commit has:
>>>
>>>     Cc: stable@vger.kernel.org [>=3.5]
>>>
>>> and so I ignored it for 3.2.  Is it actually needed for the earlier
>>> stable series?
>>
>> Crud, I missed that somehow :(
>>
>> Trond, should I revert this in 3.0 and 3.4 stable kernels?
> 
> Hi Greg,
> 
> Applying it to those kernels should be unnecessary but harmless, so if you've already applied them then I'd say just keep them.
> 
> Cheers
>   Trond


Trond hi

I do hit this with objects layout also in 3.2.
I know that in files-layout it only hits post 3.5
But we've been using layout-return since 3.0

Thanks
Boaz
