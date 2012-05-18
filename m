Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2ERPbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:31:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35830 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344Ab2ERPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:31:12 -0400
Message-ID: <1337355068.2938.41.camel@dabdike.int.hansenpartnership.com>
Subject: Re: NVM Mapping API
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 18 May 2012 16:31:08 +0100
In-Reply-To: <20120518144922.GS22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
	 <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
	 <20120516173523.GK22985@linux.intel.com>
	 <1337248478.30498.24.camel@dabdike.int.hansenpartnership.com>
	 <20120517185944.GP22985@linux.intel.com>
	 <1337331833.2938.22.camel@dabdike.int.hansenpartnership.com>
	 <20120518144922.GS22985@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 10:49 -0400, Matthew Wilcox wrote:
> You're downplaying the complexity of your own solution while overstating
> the complexity of mine.  Let's compare, using your suggestion of the
> dmesg buffer.

I'll give you that one when you tell me how you use your vfs interface
simply from within the kernel.  Both are always about the same
complexity in user space ...

To be honest, I'm not hugely concerned whether the key management API is
u32 or a string.  What bothers me the most is that there will be
in-kernel users for whom trying to mmap a file through the vfs will be
hugely more complex than a simple give me a pointer to this persistent
region.

What all this tells me is that the key lookup API has to be exposed both
to the kernel and userspace.  VFS may make the best sense for user
space, but the infrastructure needs to be non-VFS for the in kernel
users.

So what you want is a base region manager with allocation and key
lookup, which you expose to the kernel and on which you can build a
filesystem for userspace.  Is everyone happy now?

James


