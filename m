Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2A0Qm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:42:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab2A0Qm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:42:28 -0500
Date: Fri, 27 Jan 2012 17:42:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel BUG due to kernel page fault
Message-ID: <20120127164219.GE19323@redhat.com>
References: <4F21D57F.7090103@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F21D57F.7090103@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 04:36:47PM -0600, Larry Finger wrote:
> Modules linked in: fuse autofs4 snd_pcm_oss snd_mixer_oss snd_seq
> snd_seq_device edd nfs nfsd lockd auth_rpcgss nfs_acl sunrpc
> exportfs ipv6 vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
> RIP: 0010:[<ffffffff811e3ecb>]  [<ffffffff811e3ecb>] strnlen+0xb/0x30
[snip]
> Call Trace:
>  [<ffffffff811e58ae>] string.isra.4+0x3e/0xd0
>  [<ffffffff811e6889>] vsnprintf+0x219/0x600
>  [<ffffffff81153093>] seq_printf+0x53/0x80
>  [<ffffffff811e21db>] ? radix_tree_lookup+0xb/0x10
>  [<ffffffff810ba5ab>] show_interrupts+0x24b/0x300
>  [<ffffffff81153474>] seq_read+0x2b4/0x3f0
>  [<ffffffff811531c0>] ? seq_lseek+0x100/0x100
>  [<ffffffff8118b651>] proc_reg_read+0x81/0xc0
>  [<ffffffff8112f967>] vfs_read+0xa7/0x160
>  [<ffffffff8112fa65>] sys_read+0x45/0x90
>  [<ffffffff813a33a2>] system_call_fastpath+0x16/0x1b

This is call trace from cat /proc/interrupts, seems something pass
malformed string to request_irq(). I do not think this is rtlwifi,
rather that vbox thing.

Stanislaw
