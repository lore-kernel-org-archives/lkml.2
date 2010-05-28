Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab0E1QT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:19:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0E1QTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:19:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=AESHHxUawgOSgpiyOgohLtEgjEdJ19iyAu35IlOaFyP4wiS5FJPKjcMcHpmRh1ERF
	iazFmK7Wb6xm1Sc0+zQxw==
MIME-Version: 1.0
In-Reply-To: <c4716a7a5639fd8f82dc6f2046b127e65a3851c5.1275026041.git.len.brown@intel.com>
References: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
	<1275026521-30835-1-git-send-email-lenb@kernel.org>
	<c4716a7a5639fd8f82dc6f2046b127e65a3851c5.1275026041.git.len.brown@intel.com>
Date: Fri, 28 May 2010 09:19:22 -0700
Message-ID: <AANLkTikRUyXMcIkqc3dRCtLPkKBOwOeyy_j1iILHeypj@mail.gmail.com>
Subject: Re: [PATCH 7/8] ACPI: acpi_idle: touch TS_POLLING only in the 
	non-MWAIT case
From: Venkatesh Pallipadi <venki@google.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:02 PM, Len Brown <lenb@kernel.org> wrote:
> From: Len Brown <len.brown@intel.com>
>
> commit d306ebc28649b89877a22158fe0076f06cc46f60
> (ACPI: Be in TS_POLLING state during mwait based C-state entry)
> fixed an important power & performance issue where ACPI c2 and c3 C-states
> were clearing TS_POLLING even when using MWAIT (ACPI_STATE_FFH).
> That bug had been causing us to receive redundant scheduling interrups
> when we had already been woken up by MONITOR/MWAIT.
>
> Following up on that...
>
> In the MWAIT case, we don't have to subsequently
> check need_resched(), as that c heck was there
> for the TS_POLLING-clearing case.
>
> Note that not only does the cpuidle calling function
> already check need_resched() before calling us, the
> low-level entry into monitor/mwait calls it twice --
> guaranteeing that a write to the trigger address
> can not go un-noticed.

Ack this part of the change.

> Also, in this case, we don't have to set TS_POLLING
> when we wake, because we never cleared it.

I thought about this part of the change while working on the original
patch. But decided to leave the set to be done unconditionally as in
this case we are replacing "one write" by either "one read and one
jump" or "one read and one write" and I am not sure we gain much by
that.

Thanks,
Venki
