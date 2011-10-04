Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab1JDSKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:10:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35538 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab1JDSKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:10:24 -0400
Message-ID: <4E8B4BEC.5030708@zytor.com>
Date: Tue, 04 Oct 2011 11:09:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
References: <1317750395.18063.11.camel@gandalf.stny.rr.com> <20111004180237.GA15087@suse.de>
In-Reply-To: <20111004180237.GA15087@suse.de>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 11:02 AM, Greg KH wrote:
> On Tue, Oct 04, 2011 at 01:46:34PM -0400, Steven Rostedt wrote:
>> +my $pgp = `gpg --simple-sk-checksum -a --detach-sign $pass --output - < $tmpfile`;
> 
> Try not to use gpg when calling from scripts, use gpgv instead, it
> handles things much better, and sets the return value correctly so you
> can check it (which I don't think you do here.)
> 

gpgv is only usable to verify contents (equivalent to gpg --verify).
For other things you need to use gpg's --status-fd feature, *or*
(perhaps better) run gpgv on the output to verify that you actually got
a good signature.

	-hpa
