Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0L3P7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 10:59:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59905 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0L3P7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 10:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C3CvlUlC6obBlvlBzJTnqKPufsrtFoE0qCTqUjDaTSLYK7OdhzP3SNG2fGEDFqEEQd
         +jpTM+nLeRuIRxrduot6NBUlRU5hsOrsJPJL2x7icoEYGdN4Pl474wsvkIW0npRcLbz2
         +wSDBQsFQJPh1+GJtyreizko7uWU5bbC/8GE8=
MIME-Version: 1.0
In-Reply-To: <1293723098.25156.2.camel@jaguar>
References: <201012301608.40859.pluto@agmk.net>
	<1293723098.25156.2.camel@jaguar>
Date: Thu, 30 Dec 2010 17:59:31 +0200
X-Google-Sender-Auth: yZrH-Z6l70rbiYY9iijy-IBYOAY
Message-ID: <AANLkTima_+2K2ryNxOcBapS1+3jbNp=4epMzegr2rLpM@mail.gmail.com>
Subject: Re: [2.6.37-rc8] BUG kmalloc-256: Poison overwritten.
From: Pekka Enberg <penberg@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pawel Sikora <pluto@agmk.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, neilb@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 5:31 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Thu, 2010-12-30 at 16:08 +0100, Pawel Sikora wrote:
>> [ 1863.448308] =============================================================================
>> [ 1863.448313] BUG kmalloc-256: Poison overwritten
>> [ 1863.448315] -----------------------------------------------------------------------------
>> [ 1863.448316]
>> [ 1863.448319] INFO: 0xffff8807ffc7e7c4-0xffff8807ffc7e7c5. First byte 0x6c instead of 0x6b
>> [ 1863.448331] INFO: Allocated in setup_conf+0x12b/0x360 [raid10] age=554800 cpu=5 pid=2766
>> [ 1863.448336] INFO: Freed in stop+0x66/0x80 [raid10] age=4271 cpu=3 pid=5266
>> [ 1863.448339] INFO: Slab 0xffffea001bff3b90 objects=24 used=11 fp=0xffff8807ffc7e7b0 flags=0x6000000000040c1
>> [ 1863.448341] INFO: Object 0xffff8807ffc7e7b0 @offset=1968 fp=0xffff8807ffc7f338
>> [ 1863.448343]
>> [ 1863.448345] Bytes b4 0xffff8807ffc7e7a0:  a9 c6 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ����....ZZZZZZZZ
>> [ 1863.448353]   Object 0xffff8807ffc7e7b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448362]   Object 0xffff8807ffc7e7c0:  6b 6b 6b 6b 6c 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkllkkkkkkkkkk
>> [ 1863.448369]   Object 0xffff8807ffc7e7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448377]   Object 0xffff8807ffc7e7e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448384]   Object 0xffff8807ffc7e7f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448391]   Object 0xffff8807ffc7e800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448399]   Object 0xffff8807ffc7e810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448406]   Object 0xffff8807ffc7e820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448413]   Object 0xffff8807ffc7e830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448421]   Object 0xffff8807ffc7e840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448428]   Object 0xffff8807ffc7e850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448435]   Object 0xffff8807ffc7e860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448442]   Object 0xffff8807ffc7e870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448450]   Object 0xffff8807ffc7e880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448457]   Object 0xffff8807ffc7e890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [ 1863.448464]   Object 0xffff8807ffc7e8a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
>> [ 1863.448472]  Redzone 0xffff8807ffc7e8b0:  bb bb bb bb bb bb bb bb                         ��������
>> [ 1863.448478]  Padding 0xffff8807ffc7e8f0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
>> [ 1863.448487] Pid: 5282, comm: udevd Not tainted 2.6.37-rc8 #1
>> [ 1863.448489] Call Trace:
>> [ 1863.448499]  [<ffffffff8111ea1e>] print_trailer+0xfe/0x160
>> [ 1863.448503]  [<ffffffff8111f074>] check_bytes_and_report+0xf4/0x130
>> [ 1863.448506]  [<ffffffff8111f2da>] check_object+0x22a/0x270
>> [ 1863.448512]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
>> [ 1863.448515]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
>> [ 1863.448519]  [<ffffffff81120380>] alloc_debug_processing+0x110/0x1f0
>> [ 1863.448522]  [<ffffffff811211c9>] __slab_alloc+0x3a9/0x410
>> [ 1863.448528]  [<ffffffff8140254c>] ? do_page_fault+0x1cc/0x4b0
>> [ 1863.448531]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
>> [ 1863.448534]  [<ffffffff81121888>] kmem_cache_alloc_notrace+0xb8/0xc0
>> [ 1863.448538]  [<ffffffff81137cc9>] do_execve+0x59/0x390
>> [ 1863.448543]  [<ffffffff8121f0c1>] ? strncpy_from_user+0x31/0x50
>> [ 1863.448548]  [<ffffffff8100b205>] sys_execve+0x45/0x70
>> [ 1863.448553]  [<ffffffff8100319c>] stub_execve+0x6c/0xc0
>> [ 1863.448556] FIX kmalloc-256: Restoring 0xffff8807ffc7e7c4-0xffff8807ffc7e7c5=0x6b
>> [ 1863.448557]
>> [ 1863.448559] FIX kmalloc-256: Marking all objects used
>
> This looks like a use-after-free bug somewhere in drivers/md/raid10.c.

Does reverting commit 4e78064f42ad474ce9c31760861f7fb0cfc22532 ("md:
Fix possible deadlock with multiple mempool allocations.") fix the
problem?
