Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab0JZMii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:38:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56982 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0JZMih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:38:37 -0400
Date: Tue, 26 Oct 2010 14:38:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kvm@vger.kernel.org, avi@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: fyi: gcc33-hammer crashes when compiling kvm emulate.c
Message-ID: <20101026123828.GA30434@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While doing a test run with the minimum supported compiler
I found:

An old gcc 3.3-hammer segfaults when compiling the current KVM
emulate.c (or rather in x86_emulate_insns) on x86-64.

The compiler goes into an endless recursion in validate_rtx and then
eventually overflows the stack and dies.

I minimized a test case, but didn't find a workaround
(minimized test case http://halobates.de/emulate-min.i)

My guess it's related to some of the inline assembler uses.

This might be an excuse to bump the minimum compiler version again.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
