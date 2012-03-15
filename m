Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031391Ab2COAdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:33:55 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46431 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab2COAdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:33:52 -0400
MIME-Version: 1.0
In-Reply-To: <4F61278A.4000908@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
	<CAMe9rOpGgs9hR31Jxk8ycMNnEoCzUV2_xTeeE+uaEFgz5AEEwQ@mail.gmail.com>
	<4F61278A.4000908@zytor.com>
Date: Wed, 14 Mar 2012 17:33:51 -0700
Message-ID: <CAMe9rOpd1TGC8GbF-a_U+iYyHn=SwZ+ATBkuBxP5m-VmpRym8A@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 4:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/14/2012 04:17 PM, H.J. Lu wrote:
>>
>> Just for the record, although the offsets of _utime and _stime are
>> multiple of 8 bytes, struct siginfo is only aligned at 4 bytes.  So
>> the addresses of  _utime and _stime may not be 8byte aligned.
>> But misaligned int64 load/store are OK for x86-64.
>>
>
> Yes; the real question I guess is where struct siginfo appears and if it
> is misaligned by construction.  It obviously appears in the signal stack
> frame but also in a couple of system calls.  It might be possible to put
> an __attribute__((aligned(8))) on the whole structure in the x32 case?

It is possible to add  __attribute__((aligned(8))) on struct siginfo
in the x32 case.  But it only affects system calls with struct siginfo.
The signal stack frame may still be misaligned.

-- 
H.J.
