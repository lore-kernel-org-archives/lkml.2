Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab1KSOPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 09:15:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56201 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1KSOPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 09:15:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111119100326.GA27967@infradead.org>
References: <1321612791-4764-1-git-send-email-amwang@redhat.com> <20111119100326.GA27967@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 19 Nov 2011 15:14:48 +0100
Message-ID: <CAPXgP10q8Fba3vr0zf-XBBaRPwjP7MyJ=-QRL45_8WC-vtotOg@mail.gmail.com>
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
To: Christoph Hellwig <hch@infradead.org>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 11:03, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Nov 18, 2011 at 06:39:50PM +0800, Cong Wang wrote:
>> It seems that systemd needs tmpfs to support fallocate,
>> see http://lkml.org/lkml/2011/10/20/275. This patch adds
>> fallocate support to tmpfs.
>
> What for exactly?  Please explain why preallocating on tmpfs would
> make any sense.

To be able to safely use mmap(), regarding SIGBUS, on files on the
/dev/shm filesystem. The glibc fallback loop for -ENOSYS on fallocate
is just ugly.

Kay
