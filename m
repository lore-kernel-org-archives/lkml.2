Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1GNUi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:38:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1GNUi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:38:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tr1QYoJN3auFPBEBmDQz00d/7rAuShBHdnxh6B4h5RDjP9HFK6SMNoYpQYITxCkZz
	D21YFDb9bi2j02Vqgy9YQ==
MIME-Version: 1.0
In-Reply-To: <4E1F5380.9020709@zytor.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <1310675693-9204-2-git-send-email-mikew@google.com> <4E1F5380.9020709@zytor.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 14 Jul 2011 13:38:35 -0700
Message-ID: <CAGTjWtD8Obn0LsXr+Dq7xqQEYnY4UV7CAiO2+L2LLpv_1s_ufw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 1:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/14/2011 01:34 PM, Mike Waychison wrote:
>> In some build environments, it is useful to allow disabling of IO
>> accesses to hardware, without having to rely on CAP_SYS_RAWIO (which is
>> already overloaded to mean many other things).  One way that userland
>> has access to IO accesses is via the iopl(2) and ioperm(2) system calls.
>>
>> Allow disabling of these system calls from ever being available via a
>> configuration option, X86_SYS_IOPL.   This is implemented by simply
>> stubbing out the system calls and having them return ENOSYS when their
>> functionality is disabled.
>>
>> Note that we default this option to 'y', so that existing kernel configs
>> will continue to support sys_iopl and sys_ioperm as before.
>>
>
> Wouldn't it be more useful for this to be a sysctl?  In particular, like
> many similar things it probably should be a lockable sysctl (three
> states: enabled, disabled, and locked-disabled).
>
> Making it a compile-time option I'm very skeptical to.

Are there existing examples of this already in the tree?
