Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1GZAOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:14:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZAOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:14:24 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=YcSQCk7RdPjxqm_JmiQA:9 a=OKupeRZDWZOYYvmCcE8A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <CACqU3MWc7fknt9vJfKfFcv0Oe6CYSGmgMy87e+W=7D74tCKv1g@mail.gmail.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1311618747.3526.32.camel@gandalf.stny.rr.com>
	 <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	 <1311625197.3526.35.camel@gandalf.stny.rr.com>
	 <CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	 <1311637788.3526.38.camel@gandalf.stny.rr.com>
	 <CACqU3MWc7fknt9vJfKfFcv0Oe6CYSGmgMy87e+W=7D74tCKv1g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 20:14:22 -0400
Message-ID: <1311639262.3526.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 19:52 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Jul 25, 2011 at 7:49 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2011-07-25 at 18:38 -0400, Arnaud Lacombe wrote:
> >> Hi,
> >>
> >> On Mon, Jul 25, 2011 at 4:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> > On Mon, 2011-07-25 at 15:43 -0400, Arnaud Lacombe wrote:
> >> >
> >> >> Actually, we have a special uninitialized_var(x) macro to handle such
> >> >> false positive. From include/linux/compiler-gcc.h:
> >> >>
> >> >> /*
> >> >>  * A trick to suppress uninitialized variable warning without generating any
> >> >>  * code
> >> >>  */
> >> >> #define uninitialized_var(x) x = x
> >> >
> >> > I'm aware of that too, but I think that is inappropriate as well. As I
> >> > said, some versions of gcc report it, others don't. Seems that gcc 4.6.0
> >> > says this is an error where 4.5.1 does not (I just tried both).
> >> >
> >> did you ? gcc 4.5.1 from Fedora 14 definitively shows the warning:
> >
> > Heh, I didn't use Fedora's version. I wonder if they added a patch or
> > built it differently. I built my own 4.5.1 as well as my own 4.6.0.
> >
> I'd assume you're building with -O2, the warning only shows up at -Os,
> see my previous mail.

No I had CONFIG_CC_OPTIMIZE_FOR_SIZE=y (which should do the -Os). I
could also compile with V=1 but I'm in the middle of other things at the
moment.

But I just realized you are doing i386, while I'm compiling with x86_64.
That could also be the difference.

Anyway, I'll look at what it produces and see if this is a bug or not.

-- Steve


