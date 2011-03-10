Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1CJB2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 20:28:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1CJB2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 20:28:08 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CcQ3_Er_D9TCtUdHArgA:9 a=rGbluIWYie_2MCkivqwwDpIJidgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <1299720102.15854.269.camel@gandalf.stny.rr.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
	 <1299720102.15854.269.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 20:28:06 -0500
Message-ID: <1299720486.15854.271.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 20:21 -0500, Steven Rostedt wrote:
> On Wed, 2011-03-09 at 15:58 -0800, David Sharp wrote:
> > This reverts commit 6c696cec3f264a9399241b6e648f58bc97117d49.
> > 
> > Make has default values CC and AR of 'cc' and 'ar' respectively. This means
> > that "CC ?= anything" will never have effect, because CC is always already set.
> > Because of this, 6c696cec makes setting CROSS_COMPILE from the command line or
> > environment useless.
> 
> Darren, can you verify this, as you were the one to make the original
> change. I never had to cross compile it, I always did it natively.

OK, I just proved that David is correct, with the following make file:

---
CC ?= foo
AR ?= bar
all:
	echo what is $(CC) $(AR)
---

$ make
what is cc ar


Darren, can you just give an Acked-by anyway. I hate to apply a revert
of your patch without you doing so.

Thanks,

-- Steve


