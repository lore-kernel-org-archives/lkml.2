Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1CJCmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:42:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1CJCmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:42:19 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Gb42VjZYrUjGsfv7tjEA:9 a=9BO2Zcvr_UECGP1dNpHYnVq1PxQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <4D783038.8080103@linux.intel.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
	 <4D7828F9.7000906@linux.intel.com>
	 <1299720997.15854.276.camel@gandalf.stny.rr.com>
	 <4D783038.8080103@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 21:42:17 -0500
Message-ID: <1299724937.15854.277.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 17:58 -0800, Darren Hart wrote:
> On 03/09/2011 05:36 PM, Steven Rostedt wrote:
> > On Wed, 2011-03-09 at 17:27 -0800, Darren Hart wrote:
> >> On 03/09/2011 03:58 PM, David Sharp wrote:
> >>> This reverts commit 6c696cec3f264a9399241b6e648f58bc97117d49.
> >>>
> >>> Make has default values CC and AR of 'cc' and 'ar' respectively. This means
> >>> that "CC ?= anything" will never have effect, because CC is always already set.
> >>> Because of this, 6c696cec makes setting CROSS_COMPILE from the command line or
> >>> environment useless.
> >>
> >> The problem with this approach is it prevents the user from setting CC
> >> explicitly with the environment which is a very common way of using a
> >> specific version of gcc (for example). It also places restrictions on
> >> the filename of the compiler (it must end in gcc - so gcc-4.5.1 cannot
> >> work), this isn't acceptable.
> >>
> >> You could use CC=your-cross-compiler, and if that doesn't work for you,
> >> you could prepare a patch that conditionally sets CC only if
> >> CROSS_COMPILE is set, but please do not simply revert this patch which
> >> solved a real problem with the Makefile.
> >
> > Hmm, but the thing is, the change did not work,
> 
> It did work for me as I was setting CC= on the command line.
> 
> unless your environment
> > for some reason does not supply a 'cc'. Or that 'cc' defaulted to the
> > compiler that you wanted, where 'gcc' would not.
> >
> > Thus, would you be fine with something like:
> >
> > 	BUILD_CC ?=	$(CROSS_COMPILE)gcc
> > 	CC	 =	$(BUILD_CC)
> 
> This would also work, but what is wrong with:
> 
> dvhart@doubt:templates$ cat Makefile
> ifdef CROSS_COMPILE
> CC = $(CROSS_COMPILE)gcc
> AR = $(CROSS_COMPILE)ar
> endif
> 
> all:
> 	echo "CC: $(CC)"
> 
> dvhart@doubt:templates$ make -s
> CC: cc
> 
> dvhart@doubt:templates$ CC=gcc-4.5.1 make -s
> CC: gcc-4.5.1
> 
> dvhart@doubt:templates$ CROSS_COMPILE=my-cross- make -s
> CC: my-cross-gcc
> 
> 
> Seems to meet everyone's needs without changing any tools/scripts/etc 
> that have used trace-cmd before or after the CC ?= wreckage.
> 

OK, I'm fine with this.

David, want to send another patch with Darren's suggestion?

-- Steve


