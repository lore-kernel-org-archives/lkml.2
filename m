Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1KXDI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:08:28 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:52912 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab1KXDI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:08:27 -0500
Date: Thu, 24 Nov 2011 03:05:55 +0000
From: William Van <William.Van@huawei.com>
Subject: [Help]  The kernel crashed after merging the iscsi patch .
In-reply-to: <1321951821.12077.0.camel@dabdike.c.hospitality.swisscom.com>
X-Originating-IP: [10.166.82.168]
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <176A8598E62E0048838E40BB7BB429E6F42F79@szxeml528-mbs.china.huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: zh-CN
Accept-Language: zh-CN, en-US
Thread-topic: [Help]  The kernel crashed after merging the iscsi patch .
Thread-index: AQHMqlX735BxB6GLQ0u9+ClqMfX77g==
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-CFilter-Loop: Reflected
References: <176A8598E62E0048838E40BB7BB429E6F42F02@szxeml528-mbs.china.huawei.com>
 <1321951821.12077.0.camel@dabdike.c.hospitality.swisscom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAO38f7B011670

First, I'm so sorry because I've forgotten the Email subject.  During these days ,I'm doing more tests.

After merging the patch http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=0ccd644ce6a803b4f7ae5b3b4da614b8a51037cc,  the kernel crashed for an oops problem ,when I log out the iscsi session with command line "iscsiadm -m session -r sid -u" , and the call trace will be shown at the last of this text.

The function __scsi_remove_device() will be called when excecuting command line "iscsiadm -m session -r sid -u".After __scsi_remove_device() has been called, e->ops is set NULL by calling the function elevator_exit(). But the e->ops can be used util the sdev release function is called,then we can get an oops.

I have tried to roll back this patch to do some test, the oops problem never occurred again,because e->ops is set NULL when sdev release function is called.The e->ops will not be used after sdev release.

So do you have met such problem or have some thoughts with this problem?   

The call trace of this oops problem as follows: 

Trap number:14, message:Oops
Error num: 0
Sigal Num:11_SIGSEGV
Event ID:DIE_OOPS
RIP: e030:[<ffffffff801b53c2>]
<ffffffff801b53c2>{elv_completed_request+0x72}
RSP: e02b:ffff88000202fdb0  EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff8800fae5cca0 RCX: 0000000000000000
RDX: ffff8800fcbed4c0 RSI: ffff8800fc93b060 RDI: ffff8800fae5cca0
RBP: ffff8800fc93b060 R08: ffff8800fe7a9040 R09: 0000000000000001
R10: 000000010053fd4c R11: 0000000000000067 R12: ffff8800fae5cca0
R13: ffff8800fae5cca0 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0f11db5700(0000) GS:ffff88000202c000(0000) knlGS:0000000000000000
CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000050 CR3: 00000000c596a000 CR4: 0000000000002620
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<kernel_trace>
       <ffffffff80009b05>{dump_trace+0x65}
       <ffffffff8037b66b>{__die+0x8b}
       <ffffffff8001bed1>{no_context+0xd1}
       <ffffffff8001c1f5>{__bad_area_nosemaphore+0x175}
       <ffffffff8037abf8>{page_fault+0x28}
       <ffffffff801b53c2>{elv_completed_request+0x72}
       <ffffffff801b7d97>{__blk_put_request+0x27}
       <ffffffff801b83aa>{blk_end_bidi_request+0x4a}
       <ffffffffa0008309>{scsi_mod:scsi_io_completion+0x119}
       <ffffffff801bd8e5>{blk_done_softirq+0x85}
       <ffffffff80043c4e>{__do_softirq+0xde}
       <ffffffff80007f2c>{call_softirq+0x1c}
       <ffffffff800095c5>{do_softirq+0xa5}
       <ffffffff80043ab5>{irq_exit+0x55}
       <ffffffff8027c6d2>{evtchn_do_upcall+0x2f2}
       <ffffffff8000798e>{do_hypervisor_callback+0x1e}
       [<ffffffff800033aa>]
       <ffffffff8000a8af>{xen_safe_halt+0xcf}
       <ffffffff8000deed>{xen_idle+0x5d}
       <ffffffff800065bf>{cpu_idle+0x5f}
</kernel_trace>



Thanks & Best Wishes.

William Van 



> -----é‚®ä»¶åŸä»¶-----
> å‘ä»¶äºº: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> å‘é€æ—¶é—´: 2011å¹´11æœˆ22æ—¥ 16:50
> æ”¶ä»¶äºº: William Van
> ä¸»é¢˜: Re:
> 
> On Tue, 2011-11-22 at 07:30 +0000, William Van wrote:
> > Hi,J.
> > After merging the patch
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=0c
> cd644ce6a803b4f7ae5b3b4da614b8a51037cc,  the kernel crashed for an
> oops problem ,when I log out the iscsi session with command line "iscsiadm -m
> session -r sid -u" , and the call trace will be shown at the last of this text.
> 
> Could you send this to linux-scsi@vger.kernel.org (along with a proper
> subject line and the kernel version)?
> 
> Thanks,
> 
> James
> 
> 
> > After analyzing the function __scsi_remove_device(), which will be called
> while excecuting command line "iscsiadm -m session -r sid -u", I found that this
> function will send an request with cmd[0]=SYNCHRONIZE_CACHE and then
> wait for the request's completion before removing the target device. When
> this SYNCHRONIZE_CACHE request is completed, the function scsi_free_queue()
> will be called to release the scsi device's request queue and then e->ops will be
> set NULL by calling the function elevator_exit().
> >
> > By my guess, when the normal io request get completed after calling the
> function elevator_exit(), we may use e->ops that has been NULL in the normal
> io request end's callback function elv_completed_request(), and then the oops
> problem occurs. I have tried to roll back this patch to do some test, finding
> that the function scsi_free_queue() and elevator_exit() are not called, and the
> oops problem never occurred again.
> >
> > So do you have met such problem or have some thoughts with this problem?
> >
> > Thanks.
> >
> > The call trace of this oops problem as follows:
> >
> > Trap number:14, message:Oops
> > Error num: 0
> > Sigal Num:11_SIGSEGV
> > Event ID:DIE_OOPS
> > RIP: e030:[<ffffffff801b53c2>]
> > <ffffffff801b53c2>{elv_completed_request+0x72}
> > RSP: e02b:ffff88000202fdb0  EFLAGS: 00010002
> > RAX: 0000000000000000 RBX: ffff8800fae5cca0 RCX: 0000000000000000
> > RDX: ffff8800fcbed4c0 RSI: ffff8800fc93b060 RDI: ffff8800fae5cca0
> > RBP: ffff8800fc93b060 R08: ffff8800fe7a9040 R09: 0000000000000001
> > R10: 000000010053fd4c R11: 0000000000000067 R12: ffff8800fae5cca0
> > R13: ffff8800fae5cca0 R14: 0000000000000000 R15: 0000000000000000
> > FS:  00007f0f11db5700(0000) GS:ffff88000202c000(0000)
> knlGS:0000000000000000
> > CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
> > CR2: 0000000000000050 CR3: 00000000c596a000 CR4:
> 0000000000002620
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> <kernel_trace>
> >        <ffffffff80009b05>{dump_trace+0x65}
> >        <ffffffff8037b66b>{__die+0x8b}
> >        <ffffffff8001bed1>{no_context+0xd1}
> >        <ffffffff8001c1f5>{__bad_area_nosemaphore+0x175}
> >        <ffffffff8037abf8>{page_fault+0x28}
> >        <ffffffff801b53c2>{elv_completed_request+0x72}
> >        <ffffffff801b7d97>{__blk_put_request+0x27}
> >        <ffffffff801b83aa>{blk_end_bidi_request+0x4a}
> >        <ffffffffa0008309>{scsi_mod:scsi_io_completion+0x119}
> >        <ffffffff801bd8e5>{blk_done_softirq+0x85}
> >        <ffffffff80043c4e>{__do_softirq+0xde}
> >        <ffffffff80007f2c>{call_softirq+0x1c}
> >        <ffffffff800095c5>{do_softirq+0xa5}
> >        <ffffffff80043ab5>{irq_exit+0x55}
> >        <ffffffff8027c6d2>{evtchn_do_upcall+0x2f2}
> >        <ffffffff8000798e>{do_hypervisor_callback+0x1e}
> >        [<ffffffff800033aa>]
> >        <ffffffff8000a8af>{xen_safe_halt+0xcf}
> >        <ffffffff8000deed>{xen_idle+0x5d}
> >        <ffffffff800065bf>{cpu_idle+0x5f} </kernel_trace>
> >
> >
> >
> > -----
> > Thanks & Best Wishes.
> >
> > William Van
> >
> >
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
