Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2H0N7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 09:59:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37668 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2H0N7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 09:59:05 -0400
Date: Mon, 27 Aug 2012 15:58:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org,
        gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
Message-ID: <20120827135859.GY16230@one.firstfloor.org>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827112503.10313.62594.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 04:55:03PM +0530, Naveen N. Rao wrote:
> Many MCE boot flags are boolean in nature, but are declared as integers
> currently. We can pack these into a bitfield to save some space.

Note that this doesn't necessarily save anything because it needs more
code to access, and accesses are more common than the flag

	cmpl  $0,foo(%rip)            7 bytes
        testl $1,foo(%rip)           10 bytes
        bt    $0,foo(%rip)            8 bytes

Even worse for writes. The best you can usually do is to use chars on
x86.

-Andi
