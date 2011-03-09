Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab1CIOV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:21:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33417 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1CIOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nj1IoShpjeQ7e5q6WJ8myRvweWSkmoyoCrozWmaGqU1MxbaBCxPJxEG2K8kbuBm8ry
         h16C0S0gCuPxcRIZV4gh0449ELFN/fg0i5k2dWScNeZ2CguC9PZKpYM4zKMRVVsJkgFJ
         ChgndXUxLKBhKzI9XesW5ll2lws+hFD+T+UxI=
Date: Wed, 9 Mar 2011 22:21:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be
 overridden
Message-ID: <20110309142108.GD16951@cr0.redhat.com>
References: <20100825002258.GD28360@kryten>
 <m139u37cii.fsf@fess.ebiederm.org>
 <4D771EE6.5050404@linux.vnet.ibm.com>
 <20110309122046.GC16951@cr0.redhat.com>
 <20110309234657.264d3080@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309234657.264d3080@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 11:46:57PM +1100, Anton Blanchard wrote:
>
>Hi,
>
>> The crashkernel region is specified via kernel cmdline, so why
>> not just drop a failure when it overlaps with RMO region?
>> Am I missing something?
>
>Unfortunately a ppc64 kernel requires a chunk of RMO memory. We would
>need the ability to specify multiple crashkernel regions - about 32MB
>in the RMO and the rest can be anywhere. That sounds pretty fragile for
>a user to configure successfully on the cmdline.
>
>Thats why the ppc64 crashkernel region begins mid way through the RMO
>region. It means both kernels get a chunk of RMO and we only have to
>deal with one crashkernel reservation in all the tools and
>documentation.
>

So, when I specify 128M in cmdline, 32M of them are RMO, and the
rest 96M are normal memory? And when I want to free all of them,
actually the 32M RMO will never be freed?

