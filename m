Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab2LNXaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:30:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51765 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab2LNXaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:30:10 -0500
Message-ID: <50CBB661.2020603@zytor.com>
Date: Fri, 14 Dec 2012 15:29:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        criu@openvz.org, mingo@redhat.com, john.stultz@linaro.org,
        tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>  <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>  <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com>  <1355379433.24701.1.camel@wall-e>  <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com>  <1355383038.18653.2.camel@wall-e>  <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>  <50CA6E4C.6000305@zytor.com>  <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>  <50CA81A4.9040702@zytor.com>  <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com>  <50CA85BD.7070502@zytor.com>  <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com>  <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com>  <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com>  <50CAE485.5020608@parallels.com> <50CBAC61.5010600@zytor.com> <1355526568.758.5.camel@wall-e>
In-Reply-To: <1355526568.758.5.camel@wall-e>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 03:09 PM, Stefani Seibold wrote:
> 
> Sorry for not following the discussion, but im am currently trying to
> compile the vclocktime.c as a 32 bit object. Most of the (clever) work
> is done.
> 
> After this the next step is to map the needed fixmaps into the 32 bit
> address space. Maybe this can be done with install_special_mapping().
> 

install_special_mapping() is indeed how it is done.  The suggestion is
to make the vvar page an actual section inside the vdso, and then just
substitute the vvar page into the mapping array when installing the vdso
into the process user space.

	-hpa


