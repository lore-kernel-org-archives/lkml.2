Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1JDTiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:38:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314Ab1JDTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:38:22 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=ccdOYuaMiZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=nURBXIvVMNPFyoc1lt4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
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
Date: Tue, 04 Oct 2011 15:38:20 -0400
In-Reply-To: <4E8B4BEC.5030708@zytor.com>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de> <4E8B4BEC.5030708@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317757101.18063.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 11:09 -0700, H. Peter Anvin wrote:

> gpgv is only usable to verify contents (equivalent to gpg --verify).
> For other things you need to use gpg's --status-fd feature, *or*
> (perhaps better) run gpgv on the output to verify that you actually got
> a good signature.

Hmm, gpgv is not quite equivalent to gpg --verify. With gpgv I get the
following error:

$ gpgv /tmp/gpgvmail-s.x /tmp/gpgvmail-d.x
gpgv: keyblock resource `/home/rostedt/.gnupg/trustedkeys.gpg': file open error
gpgv: Signature made Tue 04 Oct 2011 02:35:50 PM EDT using RSA key ID C66DAA00
gpgv: Can't check signature: public key not found


I don't have a "trustedkeys.gpg" file. Do I need to generate one?

Using gpg --verify, it doesn't complain:

$ gpg --verify /tmp/gpgvmail-s.x /tmp/gpgvmail-d.x
gpg: Signature made Tue 04 Oct 2011 02:35:50 PM EDT using RSA key ID C66DAA00
gpg: Good signature from "Steven Rostedt (Der Hacker) <rostedt@goodmis.org>"

-- Steve


