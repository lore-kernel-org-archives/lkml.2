Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1D1SBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:01:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53847 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759852Ab1D1SBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:01:21 -0400
MIME-Version: 1.0
Date: Thu, 28 Apr 2011 20:01:20 +0200
Message-ID: <BANLkTi=kTwoVYEM410_Kz6jX4Kr90rGeAQ@mail.gmail.com>
Subject: (ptrace) regs->orig_ax == -1 upon (rt_)sigreturn syscall exit
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, while ptrace()'ing a process which performs (rt_)sigreturn the
regs->orig_ax field upon syscall exit is set to -1 in
restore_sigcontext() (both in 32 and 64bit modes) with the following
comment:

regs->orig_ax = -1;     /* disable syscall checks */

As far as I understand this field (regs->orig_ax) should be a copy of
regs->ax from before syscall enter, and basically should display a
syscall number (even upon syscall exit). Therefore I was wondering if
the current behavior isn't too hackish and in order to achieve some
goals it is breaking the intended behavior. I guess I could prepare a
patch which "fixes" this unless there are any strong reasons to leave
it as is.

-- 
Robert Święcki
