Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0HXLKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0HXLKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:10:32 -0400
From: Avi Kivity <avi@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Trap and propagate divide errors when emulating DIV
Date: Tue, 24 Aug 2010 14:10:26 +0300
Message-Id: <1282648229-19575-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM recently started emulating DIV and IDIV.  However, those instructions
trap when given the right operands.  Since figuring out when to trap or not
is difficult, we just execute the instruction and see if the processor trapped
or not.

tip: please queue the first patch on fast-forward-only branch kvm.git can
     merge, or we can carry the patch in kvm.git with your ack.

Avi Kivity (3):
  x86: allow kernel exception fixup for divide errors (#DE)
  KVM: x86 emulator: add macros for executing instructions that may
    trap
  KVM: x86 emulator: trap and propagate #DE from DIV and IDIV

 arch/x86/kernel/traps.c |   10 +++++++-
 arch/x86/kvm/emulate.c  |   60 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 66 insertions(+), 4 deletions(-)

