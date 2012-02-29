Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030918Ab2B2KQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:16:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61690 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030332Ab2B2KQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:16:20 -0500
Message-ID: <4F4DFB37.8060208@cn.fujitsu.com>
Date: Wed, 29 Feb 2012 18:17:27 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com> <4F4D7F5E.5040202@cn.fujitsu.com> <4F4DF4C6.90609@redhat.com> <20120229095557.GE24600@redhat.com> <4F4DF749.7060507@redhat.com> <20120229100550.GF24600@redhat.com> <4F4DF913.5030809@redhat.com>
In-Reply-To: <4F4DF913.5030809@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-29 18:14:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-29 18:14:32,
	Serialize complete at 2012-02-29 18:14:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 02/29/2012 06:08 PM, Avi Kivity Wrote:
> On 02/29/2012 12:05 PM, Gleb Natapov wrote:
>> On Wed, Feb 29, 2012 at 12:00:41PM +0200, Avi Kivity wrote:
>>> On 02/29/2012 11:55 AM, Gleb Natapov wrote:
>>>>>>
>>>>>
>>>>> How about using a virtio-serial channel for this?  You can transfer any
>>>>> amount of information (including the dump itself).
>>>>>
>>>> Isn't it unreliable after the guest panicked? 
>>>
>>> So is calling hypercalls, or dumping, or writing to the screen.  Of
>>> course calling a hypercall is simpler and so is more reliable.
>>>
>> Yes, crash can be so severe that it is not even detected by a kernel
>> itself, so not OOPS message even printed. But in most cases if kernel is
>> functional enough to print OOPS it is functional enough to call single
>> hypercall instruction.
> 
> Why not print the oops to virtio-serial?  Or even just a regular serial
> port?  That's what bare metal does.

If virtio-serial's driver has bug or the guest doesn't have such device...

> 
>>>> Having special kdump
>>>> kernel that transfers dump to a host via virtio-serial channel though
>>>> sounds interesting. May be that's what you mean.
>>>
>>> Yes.  The "panic, starting dump" signal should be initiated by the
>>> panicking kernel though, in case the dump fails.
>>>
>> Then panic hypercall sounds like a reasonable solution.
> 
> It is, but I'm trying to see if we can get away with doing nothing.
> 

If we have a reliable way with doing nothing, it is better. But I donot
find such way.

Thanks
Wen Congyang

