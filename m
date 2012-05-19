Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab2ESGlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:41:55 -0400
Received: from nm13-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.89]:41580 "HELO
	nm13-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756460Ab2ESGlc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:41:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 250571.20249.bm@omp1035.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YIVtAGFIwDuzLcIOYrz7cdU4Ti02SjlES4CZP0ObYkHYtxZWhqDWBJmZx/u664NdziIj4NWn4BizUovSAGzgsNLbwrIhcKm0EjCCOLLFEzDaWe/Au+t2oU7gLQV/udwRS8wvKuvRWsZT+FQMikd0rJyxHQXX1s1Kr/d7m73wSTQ=;
X-YMail-OSG: Tgyu8ecVM1krfSWXdqWqQx077rvRYp4JpWxgFr9hoGgfrHZ
 0wMA23vefhL4O_PNWOKm2PSCYySHAqWT8Rn4vvWzavl620xI_XbMGVHpG0qh
 YssLvcuI6.u7T.MwvJjYnk_CRMO20zptFt4uz5rX6tyNXUePBIIIeEKZYWzV
 TsfKhK4KZvgoLWOdjgLH9fnvDvUtyuild8fx7Rxx8it8J0.tCsD3geKTedQW
 TEkcZCq_8bFdwHKzVOYG2J9R3__dK59NFOYx2DWro0GHKmX0mnOpegEu3mIq
 tYgKg8x7rDiWhPMg7tEtUvFqdUy8WFV6QdrDMoH0qIWJ8ZPsOk6XS33ymAmE
 I3.SYAVN3MRdkUz_2P70ae1Et6a93hcVc6OHvYeDEs6oMz15.CDBr8pxZZ2f
 l7Fk-
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1337409691.95873.YahooMailNeo@web121303.mail.ne1.yahoo.com>
Date: Fri, 18 May 2012 23:41:31 -0700 (PDT)
From: Sam Portolla <samportolla@yahoo.com>
Reply-To: Sam Portolla <samportolla@yahoo.com>
Subject: BUG:: NULL ptr de-ref in drop_buffers
To: ":" <linux-kernel@vger.kernel.org>
Cc: "samPortolla@yahoo.com" <samPortolla@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please include my email address above in the reply as not a subscriber; reporting a bug and looking for a fix please.


Seen a previous discussion of this in 2.6.26 under bug 395849, but it does not mention a fix.

In this case, the issue happened on 2.6.23 GNU/Linux w/ x86_64 arch. 


Logs showing the issue followed by some analysis:

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff802b3e69>] drop_buffers+0x29/0x120

RIP: 0010:[<ffffffff802b3e69>]  [<ffffffff802b3e69>] drop_buffers+0x29/0x120
RSP: 0000:ffff81026033bb00  EFLAGS: 00010207
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81025c48c7d8
RDX: 0000000000000000 RSI: ffff81026033bb40 RDI: ffff81026fb7c238
RBP: ffff81026033bb30 R08: 00000000ffffffff R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000003 R12: ffff81024ecc4000
R13: ffff81025c48c7d8 R14: ffff81026fb7c238 R15: ffff81026033bb40
FS:  0000000000000000(0000) GS:ffff810267703400(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000002b8a4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kswapd0 (pid: 322, threadinfo ffff810260338000, task ffff810262108000)
Stack:  ffff81026f9ac638 ffff81026fb7c238 ffff81025c48c7d8 ffff81025c48c7d8
 ffff81026033bd90 0000000000000001 ffff81026033bb60 ffffffff802b41c6
 0000000000000000 ffff81026fb7c238 ffff81026033be80 ffff81025c48c7d8
Call Trace:
 [<ffffffff802b41c6>] try_to_free_buffers+0x46/0xb0
 [<ffffffff80264c8e>] try_to_release_page+0x2e/0x50
 [<ffffffff8026bf73>] shrink_page_list+0x533/0x6f0
 [<ffffffff8026aa09>] release_pages+0x189/0x1c0
 [<ffffffff8026c273>] isolate_lru_pages+0xd3/0x1e0
 [<ffffffff8026c523>] shrink_inactive_list+0x163/0x410
 [<ffffffff8026cde5>] shrink_zone+0xf5/0x140
 [<ffffffff8026d507>] kswapd+0x387/0x540
 [<ffffffff802475e0>] autoremove_wake_function+0x0/0x40
 [<ffffffff8026d180>] kswapd+0x0/0x540
 [<ffffffff80246ef8>] kthread+0x68/0xa0
 [<ffffffff80229e24>] schedule_tail+0x54/0xc0
 [<ffffffff8020d058>] child_rip+0xa/0x12
 [<ffffffff80246e90>] kthread+0x0/0xa0
 [<ffffffff8020d04e>] child_rip+0x0/0x12

#### from GDB, the bh pointer in the 1st do/while loop in the drop_buffers() is NULL.


struct buffer_head *head(%r12)
This the 1st do/while loop:

0xffffffff802b3e69 <drop_buffers+41>:   mov    (%rbx),%eax

0xffffffff802b3e8d <drop_buffers+77>:   mov    0x8(%rbx),%rbx
0xffffffff802b3e91 <drop_buffers+81>:   cmp    %r12,%rbx
0xffffffff802b3e94 <drop_buffers+84>:   jne    0xffffffff802b3e69 <drop_buffers+41>

RBX: 0000000000000000


2825                    bh = bh->b_this_page;
2826            } while (bh != head);

In this do/while loop, the bh is NULL as %rbx


static int
drop_buffers(struct page *page, struct buffer_head **buffers_to_free)
{
    struct buffer_head *head = page_buffers(page);
    struct buffer_head *bh;

    bh = head;
    do {
        if (buffer_write_io_error(bh) && page->mapping)
            set_bit(AS_EIO, &page->mapping->flags);
        if (buffer_busy(bh))
            goto failed;
        bh = bh->b_this_page;
    } while (bh != head);

    do {
        struct buffer_head *next = bh->b_this_page;

        if (!list_empty(&bh->b_assoc_buffers))
            __remove_assoc_queue(bh);
        bh = next;
    } while (bh != head);
    *buffers_to_free = head;
    __clear_page_buffers(page);
    return 1;
failed:
    return 0;
}
