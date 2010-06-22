Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0FVTfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:35:34 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:34809 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0FVTfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:35:32 -0400
Date: Tue, 22 Jun 2010 21:35:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       simone.ricci@gmail.com, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Nick.Couchman@seakr.com,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
Message-ID: <20100622193530.GA26041@merkur.ravnborg.org>
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com> <4C192085.2090404@vlnb.net> <20100616.133540.189696272.davem@davemloft.net> <4C210A07.80906@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C210A07.80906@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 11:07:51PM +0400, Vladislav Bolkhovitin wrote:
>
> David Miller, on 06/17/2010 12:35 AM wrote:
>> From: Vladislav Bolkhovitin <vst@vlnb.net>
>>
>> You're building the module with incorrect compiler flags, in
>> particular somehow the "-mcmodel=medlow" option is not getting passed
>> into the module build and thus the wrong code model is being used to
>> build the module.
>>
> Thank you. This gives us the direction away from the current dead end.  
> We will make the needed changes in our Makefiles.
>
> But we surprised that such platform specific compiler flags have to be  
> manually maintained by out of the kernel tree modules developers. We  
> thought kbuild environment doing it automatically. Particularly,  
> Documentation/kbuild/modules.txt doesn't say anything about manual  
> platform specific flags.

They should all be there automagically.
A few things to try out...
What machine is this being build on?

Your Makefile contains this:
> ifeq ($(KVER),)
>   ifeq ($(KDIR),)
>     KVER = $(shell uname -r)
>     KDIR := /lib/modules/$(KVER)/build
>   endif
> else
>   KDIR := /lib/modules/$(KVER)/build
> endif
> 

But does /lib/modules/... contain a sparc kernel?

You could try to build your module using: V=1

And reply with the output. This should give a clue about what flags are picked
up from where.

Most of your Makefile looks fine - I guess we need to find the bug
in the build environmnet and not in the Makefile.

	Sam
