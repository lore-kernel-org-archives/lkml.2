Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0J3N2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:28:53 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:40556 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0J3N2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:28:51 -0400
Date: Sat, 30 Oct 2010 14:28:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Wu Zhangjin <wuzhangjin@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        John Reiser <jreiser@bitwagon.com>,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 3/3] ftrace/MIPS: Enable C Version of recordmcount
In-Reply-To: <1288186564.18238.126.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1010301414060.25426@eddie.linux-mips.org>
References: <cover.1288176026.git.wuzhangjin@gmail.com>         <bb99009a9ac79d3f55a8c8bf1c8bd2bc0e1f160e.1288176026.git.wuzhangjin@gmail.com> <1288186564.18238.126.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Steven Rostedt wrote:

> On Wed, 2010-10-27 at 18:59 +0800, Wu Zhangjin wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > Selects HAVE_C_RECORDMCOUNT to use the C version of the recordmcount
> > intead of the old Perl Version of recordmcount.
> > 
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> I'd like to get an Acked-by from Ralf and Maciej on this.

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 I have looked through it and spotted nothing obviously wrong, but I can't 
afford any further testing, especially at run time, sorry.

 One point to note -- it seems to me the code currently assumes a 32-bit 
model, i.e. the use of the -msym32 GCC option suitable for a 64-bit kernel 
loaded to a CKSEG0 address (cf. KBUILD_SYM32 in arch/mips/Makefile), tools 
support permitting.  That means it does not (correctly) support kernels 
loaded to an XPHYS address as required for some platforms (or otherwise 
chosen for testing such a configuration; modulo some processor errata and 
bootloader limitations, it is generally OK to run the kernel from XPHYS on 
64-bit chips even if the entire RAM fits into CKSEG0).

 For the avoidance of doubt -- I'm just mentioning it to emphasise a 
possible future direction for improvement of this code -- not an objection 
against this submission, that is certainly a good foundation for future 
development.

 Thanks to everybody involved.

  Maciej
