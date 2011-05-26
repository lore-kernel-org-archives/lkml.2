Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab1EZRdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:33:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52961 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab1EZRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:32:59 -0400
Date: Thu, 26 May 2011 19:32:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: Re: [RFC Patch 5/6] slimdump: Capture slimdump for fatal MCE generated crashes
Message-ID: <20110526173257.GC4065@one.firstfloor.org>
References: <20110526170722.GB23266@in.ibm.com> <20110526172305.GA18295@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526172305.GA18295@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:53:05PM +0530, K.Prasad wrote:
> 
> slimdump: Capture slimdump for fatal MCE generated crashes
> 
> System crashes resulting from fatal hardware errors (such as MCE) don't need
> all the contents from crashing-kernel's memory. Generate a new 'slimdump' that
> retains only essential information while discarding the old memory.

While this is a good idea, note there may be still poisoned lines
in memory that haven't resulted in a machine check yet, but could
still be fatal when read after a full crash dump for some other
reason.

So you still need 

http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=commit;h=fe61906edce9e70d02481a77a617ba1397573dce
and
http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=commit;h=cb58f049ae6709ddbab71be199390dc6852018cd

in addition.

-Andi
