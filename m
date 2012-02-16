Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2BPVYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:24:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34681 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2BPVYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:24:52 -0500
Message-ID: <4F3D73E3.7070409@zytor.com>
Date: Thu, 16 Feb 2012 13:23:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Markus Gutschke <markus@chromium.org>
CC: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.org, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        keescook@chromium.org
Subject: Re: [PATCH v8 5/8] seccomp: Add SECCOMP_RET_TRAP
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-5-git-send-email-wad@chromium.org> <CAE6n16mCrJC=Sre+PT1H_VfSjW0MGyi0xtEcdcRvGMvvwXWzmA@mail.gmail.com> <CAE6n16nUB8eg18YHdYbSUqtZ_WJduk4B_dYqyYy37K+6di6yVw@mail.gmail.com>
In-Reply-To: <CAE6n16nUB8eg18YHdYbSUqtZ_WJduk4B_dYqyYy37K+6di6yVw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 12:28 PM, Markus Gutschke wrote:
> On Thu, Feb 16, 2012 at 12:02, Will Drewry <wad@chromium.org> wrote:
>> Adds a new return value to seccomp filters that triggers a SIGTRAP to be delivered with the new TRAP_SECCOMP si_code.
>>
>> This allows in-process system call emulation -- including just specifying an errno or cleanly dumping core -- rather than just dying.
> 
> SIGTRAP might not be the ideal choice of signal number, as it can make
> it very difficult to debug the program in gdb. Other than that, I love
> this feature. It'll significantly simplify the code that we have in
> Chrome.
> 

Sounds like SIGSYS to me.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

