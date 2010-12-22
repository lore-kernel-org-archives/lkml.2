Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0LVS4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:56:55 -0500
Received: from relay3.sgi.com ([192.48.152.1]:58702 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751704Ab0LVS4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:56:53 -0500
Message-ID: <4D1249ED.9040008@sgi.com>
Date: Wed, 22 Dec 2010 10:56:45 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Len Brown <lenb@kernel.org>,
        Jack Steiner <steiner@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Early kernel messages are overflowing the static log buffer
References: <4D06B317.2090608@sgi.com> <20101222130946.GC13412@elte.hu> <20101222131719.GA8061@htj.dyndns.org>
In-Reply-To: <20101222131719.GA8061@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

I have a patchset almost ready for submission.  We have a giant
system (6 racks with some huge amount of nodes) for a few more
days, and the buffer still overflowed with my changes.  So I'm
making one more tweak to cut down the amount of characters 
generated without losing information.

Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 22, 2010 at 02:09:46PM +0100, Ingo Molnar wrote:
>>> [    0.000000] pcpu-alloc: [000] 0000 0001 0002 0003 0004 0005 0006 0007 1024 1025 1026 1027 1028 1029 1030 1031
>>>
>>> What I'm asking is which of these would be most acceptable to
>>> either remove or replace with some sort of message reduction?
>> The pcpu alloc messages look entirely superfluous and zappable - make them 
>> KERN_DEBUG perhaps (and Cc: Tejun)?
> 
> Yeap, with percpu allocator now mostly stable, I don't think the
> message needs to be KERN_INFO anymore.  I'll change it to KERN_DEBUG.
> 
> Thanks.
> 

This doesn't really help the log buffer overflow problem as KERN_DEBUG
messages still end up in the buffer.  The pr_debug() macro does compile
out the messages if the system does not have KERNEL debug set, though
distros also have this set as a default.

Thanks,
Mike

