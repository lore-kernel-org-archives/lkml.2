Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab1JDSSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:18:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab1JDSSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:18:08 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=ccdOYuaMiZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=omxJxpnKuCwz0Soe36cA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, Andreas Gruenbacher <agruen@suse.de>
Date: Tue, 04 Oct 2011 14:18:05 -0400
In-Reply-To: <4E8B4BEC.5030708@zytor.com>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de> <4E8B4BEC.5030708@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317752287.18063.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 11:09 -0700, H. Peter Anvin wrote:
> On 10/04/2011 11:02 AM, Greg KH wrote:
> > On Tue, Oct 04, 2011 at 01:46:34PM -0400, Steven Rostedt wrote:
> >> +my $pgp = `gpg --simple-sk-checksum -a --detach-sign $pass --output - < $tmpfile`;
> > 
> > Try not to use gpg when calling from scripts, use gpgv instead, it
> > handles things much better, and sets the return value correctly so you
> > can check it (which I don't think you do here.)
> > 
> 
> gpgv is only usable to verify contents (equivalent to gpg --verify).
> For other things you need to use gpg's --status-fd feature, *or*
> (perhaps better) run gpgv on the output to verify that you actually got
> a good signature.

Oh! That would probably save me a lot of debugging time to verify it
directly in the script :)  I've been sending lots of patches to myself
to see if it showed a valid sig or not, then try to figure out what when
wrong.

I could write a gpgverifymail.pl, to confirm that the patch that is
going out is correct.

Yeah, I think another temp file would be the right thing here to fail
nicely on issues with pgp.

Thanks!

-- Steve


