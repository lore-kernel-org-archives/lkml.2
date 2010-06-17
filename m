Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746Ab0FQUzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:55:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47454 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab0FQUzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=V2pLmcF4i2VVdQszONnd19cFX6aAnz7ZXlplq6sXkX5KAmEX5zaXjKdPg7VUovpZg5
         Fc4oC0vMI+mPleKJELIxIUXSEcgskCUcdA4rHvpd3xtX2qJ8/VEKBcYv0bVekfGvSUt7
         C6QtxzGcBP4iIBP/qS+SI8XZzUQj1xwnuC2gA=
MIME-Version: 1.0
Date: Thu, 17 Jun 2010 14:55:36 -0600
Message-ID: <AANLkTilR54xU8wpixR4LQyhKG7KV_wCLJNxT1e_3aAqr@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey Debugger for Linux 2.6.34-06-17-2010 (CR3 
	Fixes)
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-06-17-2010.patch

FIXES

Add

mov cr3,%eax
mov %eax,cr3

to main callback from notify_die() function.  Linux in various
functions will alter page tables in batches without issuing a TLB
flush command.  Daemonize() is one such function where the .mm is
deleted and no TLB flush in executed.  Such cases
require that the debugger always reload CR3 on breakpoint exceptions
to avoid double and triple faulting, and in this case
will hand the system in the page fault handler if CR3 is not reloaded
every exception to make certain the processor has a
valid view of the TLB and page tables.

Jeff
