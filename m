Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab2C1XBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:01:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51020 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab2C1XBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <1332969110-12262-1-git-send-email-vnagarnaik@google.com>
References: <CAL26m8JfVekNQC75dSmH+JDFwATdGYjyV-GBx+KrbCSeW-6V2Q@mail.gmail.com>
 <1332969110-12262-1-git-send-email-vnagarnaik@google.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 28 Mar 2012 16:00:41 -0700
Message-ID: <CAL26m8+MjdqS-f_kgui97RnfWNxPdvObCaitPRuHXAr8VCwWXg@mail.gmail.com>
Subject: Re: [PATCH 2/6] trace: add support for 32 bit compat syscalls on x86_64
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 2:11 PM, Vaibhav Nagarnaik
<vnagarnaik@google.com> wrote:
> Changelog:
> * Remove unmaintainable list of syscalls and use SYSCALL_DEFINEx macro
>  to define the metadata for equivalent compat syscall

This simplifies the patch significantly, but there are problems to
this approach.
* This doesn't trace compat syscalls which don't call the 64-bit
handler (e.g. sys32_stat64). They need COMPAT_SYSCALL_DEFINEx wrapper
macro where they are defined. I am planning to add them for x86.

* This will generate useless metadata for these syscalls. For e.g. it
will have metadata for compat_sys_lseek which does not generate a
trace-able event. Instead, there will be an event for sys32_lseek when
I add the corresponding metadata wrapper.

(BTW, I just found that I need a change to the check in
find_compat_syscall_meta(). Basically remove the prefixes "sys32_" and
"stub32_")



Vaibhav Nagarnaik
