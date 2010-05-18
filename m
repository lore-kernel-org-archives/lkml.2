Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0ERLZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:25:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58916 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0ERLZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:25:19 -0400
Date: Tue, 18 May 2010 13:25:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100518112509.GD22675@basil.fritz.box>
References: <1273887635-27610-1-git-send-email-venki@google.com> <87tyq9mqrz.fsf@basil.nowhere.org> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default> <20100515121424.38f5b389@infradead.org> <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default> <20100515224305.17a04022@infradead.org> <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain> <5adf3fee-0f7b-4039-b13f-619640cc4b88@default> <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274176698.5605.7358.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 11:58:18AM +0200, Peter Zijlstra wrote:
> On Sun, 2010-05-16 at 22:06 -0700, Arjan van de Ven wrote:
> > look we're not disabling ring 3 tsc. We could, but we don't.
> 
> Maybe we should.

That would kill the vsyscall too. Remember it's running in ring 3.

That is in theory you could disable it on systems where the vsyscall
doesn't use it, but then you would likely break huge amounts of software, 
unless you emulate it.

Emulation would be a possibility, but I'm not sure it would
make anyone really happy. It would be certainly slow.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
