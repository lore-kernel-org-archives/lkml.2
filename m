Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab2CNXT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:19:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51064 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760582Ab2CNXTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:19:51 -0400
Message-ID: <4F61278A.4000908@zytor.com>
Date: Wed, 14 Mar 2012 16:19:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org> <CAMe9rOpGgs9hR31Jxk8ycMNnEoCzUV2_xTeeE+uaEFgz5AEEwQ@mail.gmail.com>
In-Reply-To: <CAMe9rOpGgs9hR31Jxk8ycMNnEoCzUV2_xTeeE+uaEFgz5AEEwQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 04:17 PM, H.J. Lu wrote:
> 
> Just for the record, although the offsets of _utime and _stime are
> multiple of 8 bytes, struct siginfo is only aligned at 4 bytes.  So
> the addresses of  _utime and _stime may not be 8byte aligned.
> But misaligned int64 load/store are OK for x86-64.
> 

Yes; the real question I guess is where struct siginfo appears and if it
is misaligned by construction.  It obviously appears in the signal stack
frame but also in a couple of system calls.  It might be possible to put
an __attribute__((aligned(8))) on the whole structure in the x32 case?

	-hpa
