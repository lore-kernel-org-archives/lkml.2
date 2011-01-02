Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1ABNi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 08:38:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab1ABNi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 08:38:56 -0500
Message-ID: <4D207FEA.9080502@redhat.com>
Date: Sun, 02 Jan 2011 15:38:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.6.37-rc8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a couple of late KVM fixes from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37

The first fixes an issue where a guest with cr0.pg=0, accessing an 
address above 1GB, that is backed by a large host page, triggers a 
BUG_ON().  The second is a fix for a long standing virtual i8259 bug 
that was somehow exposed by the first fix.

Avi Kivity (2):
       KVM: MMU: Fix incorrect direct gfn for unpaged mode shadow
       KVM: i8259: initialize isr_ack

  arch/x86/kvm/i8259.c |    2 ++
  arch/x86/kvm/mmu.c   |    3 ++-
  2 files changed, 4 insertions(+), 1 deletions(-)

-- 
error compiling committee.c: too many arguments to function

