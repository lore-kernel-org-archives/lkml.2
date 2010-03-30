Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0C3R4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:56:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55969 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab0C3R4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:56:37 -0400
Message-ID: <4BB23B35.7060401@zytor.com>
Date: Tue, 30 Mar 2010 10:56:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>
CC: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] x86, fs: add sys_compat_write for net/socket.c
References: <1269971469-1254-1-git-send-email-fw@strlen.de>
In-Reply-To: <1269971469-1254-1-git-send-email-fw@strlen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 10:51 AM, Florian Westphal wrote:
> On some configurations, e.g. x86_64 with 32bit userspace, netlink/xfrm
> misinterprets messages from userspace due to different structure
> layout (u64 has different alignment requirements on x86 vs. x86_64).
> 
> As long as messages are sent via sendmsg(), this could be handled via
> net/compat.c; it will set the CMSG_MSG_COMPAT flag in struct msghdr
> for compat tasks, which would allow to the xfrm_user code to detect
> when messages need compat fixups.
> 
> Unfortunately, some programs (e.g. pluto ike daemon), send netlink data
> to the kernel using write().
> 
> Thus, introduce f_ops->compat_aio_write and compat_sys_write to treat
> writes on sockets specially.
> 
> This only wires up compat_sys_write for x86/x86_64 -- at the moment this
> is only required to parse xfrm netlink messages, which happen to only
> need special treatment in case of COMPAT_FOR_U64_ALIGNMENT=y.
> 
> Setting CMSG_MSG_COMPAT depending on plain is_compat_task() in net/socket.c
> was not done due to concerns regarding the kernel doing socket
> writes in response to a user event (which might set MSG_COMPAT erronously).
> 

OK... I have to ask the question:

This only applies if you're using unpacked structures with
non-naturally-aligned objects in them.  Where to we have those, and can
we shoot the authors?

	-hpa
