Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab0EEC67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:58:59 -0400
Received: from mail-qy0-f187.google.com ([209.85.221.187]:52517 "EHLO
	mail-qy0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab0EEC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:58:56 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2010 22:58:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nDt5wW/hKKAIEMqKvM1We/dC4oUw9o+cLBoxn4p0wh0GqI+lN5V+N4HkvRdLa8eMDF
         dU2d3a5eFceSPBVDakBan+O0jhPMBTB+Ja2c34QsSZgrSE1A/FjpV8hEwL0K8olyT/64
         hzq2AYQ8edCDugRLxQ1I6eQdCIhZNWHi0kgYY=
MIME-Version: 1.0
In-Reply-To: <20100505023220.GC20236@windriver.com>
References: <20100504070334.GN2657@zip.com.au> <4BDFDCD1.70202@redhat.com>
	 <20100505023220.GC20236@windriver.com>
Date: Wed, 5 May 2010 10:52:50 +0800
Message-ID: <h2p2375c9f91005041952k422e7701vf7e726fc5440e953@mail.gmail.com>
Subject: Re: 2.6.33.3: possible recursive locking detected
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: CaT <cat@zip.com.au>, lkml@zip.com.au, mtosatti@redhat.com,
       kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 10:32 AM, Yong Zhang <yong.zhang@windriver.com> wrote:
> On Tue, May 04, 2010 at 11:37:37AM +0300, Avi Kivity wrote:
>> On 05/04/2010 10:03 AM, CaT wrote:
>> >I'm currently running 2.6.33.3 in a KVM instance emulating a core2duo
>> >on 1 cpu with virtio HDs running on top of a core2duo host running 2.6.33.3.
>> >qemu-kvm version 0.12.3.
>
> Can you try commit 6992f5334995af474c2b58d010d08bc597f0f2fe in the latest
> kernel?
>

Hmm, 2.6.33 -stable has commit 846f99749ab68bbc7f75c74fec305de675b1a1bf?

Actually, these 3 commits fixed it:

6992f5334995af474c2b58d010d08bc597f0f2fe sysfs: Use one lockdep class
per sysfs ttribute.
a2db6842873c8e5a70652f278d469128cb52db70 sysfs: Only take active
references on attributes.
e72ceb8ccac5f770b3e696e09bb673dca7024b20 sysfs: Remove sysfs_get/put_active_two

However, there are many other patches needed to amend these, so I think
it's not suitable for -stable to include, perhaps a revert of
846f99749ab68bbc7f75c74fec305de675b1a1bf is better.

Adding Greg into Cc.

Thanks.
