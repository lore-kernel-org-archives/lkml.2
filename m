Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1CIMVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:21:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63662 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab1CIMVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rmo1I+84l6VQVwvmxRVkFElEfIC1fRmmuvrlmwHKi8xrgQokJSBYdQbInXBsM8SFvH
         3Zr00hgkOryYHLuIxrLhyOQu6Xpsb9joxOYXELAnjF/dUyIrE+Qs6UiQ4N1lkWiPndTr
         Kdhla0/6+bg/w6qfXpGO86oyeInffbBxEvfWE=
Date: Wed, 9 Mar 2011 20:20:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be
 overridden
Message-ID: <20110309122046.GC16951@cr0.redhat.com>
References: <20100825002258.GD28360@kryten>
 <m139u37cii.fsf@fess.ebiederm.org>
 <4D771EE6.5050404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D771EE6.5050404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 12:02:06PM +0530, Mahesh Jagannath Salgaonkar wrote:
>On 08/25/2010 06:07 AM, Eric W. Biederman wrote:
>> Anton Blanchard <anton@samba.org> writes:
>> 
>>> On ppc64 the crashkernel region almost always overlaps an area of firmware.
>>> This works fine except when using the sysfs interface to reduce the kdump
>>> region. If we free the firmware area we are guaranteed to crash.
>> 
>> That is ppc64 bug.  firmware should not be in the reserved region.  Any
>> random kernel like thing can be put in to that region at any valid
>> address and the fact that shrinking the region frees your firmware means
>> that using that region could also stomp your firmware (which I assume
>> would be a bad thing).
>The issue only happens while shrinking the region using sysfs interface.
>We already have checks in kexec for not to stomp over on the firmware
>overlap area while loading capture kernel. Currently we do a top-down
>allocation for the firmware region which means it sits at the top of the
>RMO, right in the middle of the crashdump region. We can not move the
>crashkernel region beyond firmware region because kernel needs its some
>of memory in RMO region.

The crashkernel region is specified via kernel cmdline, so why
not just drop a failure when it overlaps with RMO region?
Am I missing something?

Thanks.
