Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0LASHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:07:31 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41896 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0LASHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z9Ut3PKl1OM44V2gt1o8Vcya7dP1Yq63xGX19LBHSYSEBr2qt/xsQj/7ZYuW6RjBw7
         Kaw/4vJPNzM83tndePhta9uJ5b/GBX7a+taIo8jO9O1XhcZcdn+J7GaBKGQYM0/PB16h
         40VjFaLHUCCkN+IYFQLV7DerjRbrubVI1W0ig=
Date: Wed, 1 Dec 2010 21:07:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] x86: only call smp_processor_id in non-preempt
	cases
Message-ID: <20101201180724.GA6478@lenovo>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com> <1291156050-4482-7-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291156050-4482-7-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:27:27PM -0500, Don Zickus wrote:
> There are some paths that walk the die_chain with preemption on.
> Make sure we are in an NMI call before we start doing anything.
> 
> This was triggered by do_general_protection calling notify_die with
> DIE_GPF.
> 
> Reported-by: Jan Kiszka <jan.kiszka@web.de>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/apic/hw_nmi.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

yup, thanks Don!
 
  Cyrill
