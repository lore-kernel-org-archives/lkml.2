Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1ADWO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:14:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62474 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1ADWO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:14:56 -0500
Date: Tue, 4 Jan 2011 14:11:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>, Bob Tracy <rct@gherkin.frus.com>,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        mcree@orcon.net.nz, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] implicit declaration of kfree/kzalloc in i2c-i801.c on
 Alpha
Message-Id: <20110104141151.b6035bf3.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikyX3F+NjHVTGVV6rKyJhZQCcb3150-91La0rHs@mail.gmail.com>
References: <20110104061821.GA25886@gherkin.frus.com>
	<AANLkTikOsULOVq01CEiPuoK4-sFTk+KWJiLY0wnzUZ17@mail.gmail.com>
	<AANLkTikyX3F+NjHVTGVV6rKyJhZQCcb3150-91La0rHs@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011 22:56:18 +0200 Pekka Enberg wrote:

> On Tue, Jan 4, 2011 at 9:37 PM, Matt Turner <mattst88@gmail.com> wrote:
> > On Tue, Jan 4, 2011 at 1:18 AM, Bob Tracy <rct@gherkin.frus.com> wrote:
> >> Another 2.6.37-rc8 build failure on alpha:
> >>
> >> (...)
> >>  CC [M]  drivers/i2c/busses/i2c-i801.o
> >> drivers/i2c/busses/i2c-i801.c: In function 'i801_probe':
> >> drivers/i2c/busses/i2c-i801.c:737: error: implicit declaration of function 'kzalloc'
> >> drivers/i2c/busses/i2c-i801.c:737: warning: assignment makes pointer from integer without a cast
> >> drivers/i2c/busses/i2c-i801.c:855: error: implicit declaration of function 'kfree'
> >> make[3]: *** [drivers/i2c/busses/i2c-i801.o] Error 1
> >> make[2]: *** [drivers/i2c/busses] Error 2
> >> make[1]: *** [drivers/i2c] Error 2
> >> make: *** [drivers] Error 2
> >>
> >> --Bob
> >
> > Is this specific to alpha? I wonder why we don't see this on other platforms?
> 
> The x86 version of <asm/pci.h> includes <linux/slab.h> which hides the
> problem on x86 at least. There was a big cleanup of implicit
> <linux/slab.h> inclusions few months ago which has exposed the
> problem.
> 
> It's a bug in the driver, just add the include there.

exactly.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
