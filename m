Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2FETmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:42:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54096 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2FETml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:42:41 -0400
Message-ID: <4FCE612F.6020000@gmail.com>
Date: Tue, 05 Jun 2012 12:42:39 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next broken for MIPS by b87077280b7271c5310237e127b0fe423d443e0f(mips:
 merge the identical "return from syscall" per-ABI code)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As shown here:

http://kisskb.ellerman.id.au/kisskb/buildresult/6442834/

Commit b87077280b7271c5310237e127b0fe423d443e0f(mips: merge the 
identical "return from syscall" per-ABI code) breaks MIPS.

I suggest that on arch/mips/kernel/entry.S:173 that you do:

s/bz/beqz/

I suspect that will fix the assembler error.  Other than that, I make no 
claims about the correctness of the code in general.


David Daney
