Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0JMSBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:01:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38431 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0JMSBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v+7W9HKWWe+fT5v+48FzjkuZyG56hiXoJh5Ov0F+B1AR/bR4geOcn6VAoZvDOdeocj
         AfO/S0o64mvNVSDw77QwXU/rx/Fy02ydca7CBRuLJY/3vX8vgnGpthz83Z9EhfL4yXGP
         ivLuUD2Jv4OL6yB0oz3OEyF/xRzAxOKBY6Ukw=
MIME-Version: 1.0
In-Reply-To: <20101013075346.GA24052@linux-mips.org>
References: <f3f140ca90dc9dac2f645748bc3a0150@localhost>
	<20101013075346.GA24052@linux-mips.org>
Date: Wed, 13 Oct 2010 11:01:06 -0700
Message-ID: <AANLkTikinkyEu-ozyiHOhr1D4ZLwv0jZwbk=4jq_YM9J@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Nicolas Pitre <nico@fluxnic.net>,
        Gary King <gking@nvidia.com>
Cc: dediao@cisco.com, ddaney@caviumnetworks.com, dvomlehn@cisco.com,
        sshtylyov@mvista.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 12:53 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> It's this disabling of interrupts which I don't like.  It's easy to get
> around it by having one kmap type for each of process, softirq and
> interrupt context.

I am curious as to why ARM opted for the "pte push/pop" strategy
(kmap_high_l1_vipt()) instead of something along these lines?

Is there a reason why using 3 kmap types to solve the "interrupted
flush problem" would work for MIPS, but is not a good solution on ARM?

> The good news is that Peter Zijlstra has rewritten kmap to make the need
> for manually allocated kmap types go away and his patches are queued to
> be merged for 2.6.37.  So I'd like to put this patch on hold until after
> his patches are merged.

OK, I'll take a look at that.  Thanks for the pointer.

> Does your system have both highmem and cache aliases?

This system has HIGHMEM + SMP, no cache aliases.
