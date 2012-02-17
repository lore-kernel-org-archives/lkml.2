Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2BQBeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:34:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36203 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2BQBeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:34:00 -0500
Message-ID: <4F3DAE5D.3080000@zytor.com>
Date: Thu, 16 Feb 2012 17:33:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        keescook@chromium.org
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
References: <1329422549-16407-1-git-send-email-wad@chromium.org>    <1329422549-16407-3-git-send-email-wad@chromium.org>    <4F3D61CB.2000301@zytor.com>    <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com>    <4F3D7250.6040504@zytor.com> <501858544d264abc6526f2b25a224f2b.squirrel@webmail.greenhost.nl>
In-Reply-To: <501858544d264abc6526f2b25a224f2b.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 04:48 PM, Indan Zupancic wrote:
> On Thu, February 16, 2012 22:17, H. Peter Anvin wrote:
> 
> I would go for something like:
> 
> struct seccomp_data {
> 	int nr;
> 	__u32 arg_low[6];
> 	__u32 arg_high[6];
> 	__u32 instruction_pointer_low;
> 	__u32 instruction_pointer_high;
> 	__u32 __reserved[3];
> };
> 

Uh, that is the absolutely WORST way to do it - not only are you
creating two fields, they're not even adjacent.

> (Not sure what use the IP is because that doesn't tell anything about how
> the system call instruction was reached.)
> 
> The only way to avoid splitting args is to add 64-bit support to BPF.
> That is probably the best way forwards, but would require breaking the
> BPF ABI by either adding a 64-bit version directly or adding extra
> instructions.

Or the compiler or whatever generates the BPF code just is going to have
to generate two instructions -- just like we always have to handle
[u]int64_t on 32-bit platforms.  There is no difference here.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

