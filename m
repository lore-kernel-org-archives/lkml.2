Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1FJTGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:06:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39207 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJTGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LK1b6qYvUfF/PKMF05pA+CB/pOIhu+msOB2SI1LrXhUw2bP86Lwn/aX3J0n5Qf2lIE
         KCbdxNkUiSIZBidJjjaLTUqnMFz2d2d7zqjoCvcmnIUps0mhbcMmYyBPTkm2YaVzmqx+
         m+wXmq1GGbnIoox8R05lD6tTqHvu/Leb4NkV8=
MIME-Version: 1.0
In-Reply-To: <4DF1D0B1.1020302@jp.fujitsu.com>
References: <4df13c362729376e2@agluck-desktop.sc.intel.com>
	<4DF1D0B1.1020302@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 12:06:45 -0700
Message-ID: <BANLkTimFXpqLOpX7x-yQ2Sa+aEF4BakSnw@mail.gmail.com>
Subject: Re: [PATCH 05/10] MCE: Mask out address mask bits below address granuality
From: Tony Luck <tony.luck@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> Why do you have to mask it out in kernel, why not in user/logger?
>
> One possible story is:
>  "... the brand-new Xeon XXXX has new MCx_***_VALID bit in ****
>  register, if it is set the lower bits of MCx_ADDR indicates
>  ****, otherwise the bits are undefined ..."
>
> So I think that kernel should convey the raw value from hardware to
> userland.  Even if it contains some noise on it, user can determine
> whether it is useful or not.  And more, since this is an error record,
> there will be no second chance to retrieve the data afterward.

This is a good point - we should log the original untouched bits someplace.

But we also want to avoid having to perform this same calculation over
and over (and risk having some place miss doing it right).  So perhaps
we need to leave m->addr with the exact bits that were pulled from
MCi_ADDR - but add an <address,size> or <address,end> tuple that
has the post-calculation numbers for use in the kernel recovery code.

-Tony
