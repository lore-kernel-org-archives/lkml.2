Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1COHwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:52:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1COHwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p4mnowk4ifHo1BQB0Kroe1DsSyS+jzu12zRNrY/41mT+NVUx1wXNpnQsEX2vEtzZmD
         Q+evHW8LRXC2eAZJoSx6U3KsV3tRCnC1AyGmVBpqMRs7CjWZuWr9pL87PasETmA+RXQ7
         hU6iSsKNm64DjLOF3u074aZpsQJHcGXO4hziI=
MIME-Version: 1.0
In-Reply-To: <20110314181315.GA16075@in.ibm.com>
References: <20100825002258.GD28360@kryten>
	<m139u37cii.fsf@fess.ebiederm.org>
	<4D771EE6.5050404@linux.vnet.ibm.com>
	<20110309122046.GC16951@cr0.redhat.com>
	<20110309234657.264d3080@kryten>
	<20110309142108.GD16951@cr0.redhat.com>
	<20110314181315.GA16075@in.ibm.com>
Date: Tue, 15 Mar 2011 15:52:38 +0800
Message-ID: <AANLkTi=aDzCaa7_=5XTrnJCzmZPrDy3omXwDarEF8XmH@mail.gmail.com>
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be overridden
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: mahesh@linux.vnet.ibm.com
Cc: Anton Blanchard <anton@samba.org>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 2:13 AM, Mahesh J Salgaonkar
<mahesh@linux.vnet.ibm.com> wrote:
>
> During free we do free all of them including RMO region. But since the rtas
> region is always on top of RMO, crashkernel memory overlaps rtas region and
> we endup freeing that even, which is causing the crash.
>

Okay, but with this patch applied, we will just ignore rtas region, right?
Thus, when I echo 0 to free all the 128M crashkernel memory, the final
result will be 32M left, which means crash_size will still show 32M.
This looks odd.

How about skipping the 32M as a whole? I mean once the region being freed
has overlap with this rtas region, skip the whole rtas region, and let
crash_size
show 0?

Thanks.
