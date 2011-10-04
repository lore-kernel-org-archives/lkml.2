Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab1JDTmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:42:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36219 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314Ab1JDTmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:42:11 -0400
Message-ID: <4E8B6172.2050006@zytor.com>
Date: Tue, 04 Oct 2011 12:41:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Greg KH <gregkh@suse.de>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>  <20111004180237.GA15087@suse.de> <4E8B4BEC.5030708@zytor.com> <1317757101.18063.24.camel@gandalf.stny.rr.com>
In-Reply-To: <1317757101.18063.24.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 12:38 PM, Steven Rostedt wrote:
> 
> Hmm, gpgv is not quite equivalent to gpg --verify. With gpgv I get the
> following error:
> 
> $ gpgv /tmp/gpgvmail-s.x /tmp/gpgvmail-d.x
> gpgv: keyblock resource `/home/rostedt/.gnupg/trustedkeys.gpg': file open error
> gpgv: Signature made Tue 04 Oct 2011 02:35:50 PM EDT using RSA key ID C66DAA00
> gpgv: Can't check signature: public key not found
> 
> 
> I don't have a "trustedkeys.gpg" file. Do I need to generate one?
> 
> Using gpg --verify, it doesn't complain:
> 
> $ gpg --verify /tmp/gpgvmail-s.x /tmp/gpgvmail-d.x
> gpg: Signature made Tue 04 Oct 2011 02:35:50 PM EDT using RSA key ID C66DAA00
> gpg: Good signature from "Steven Rostedt (Der Hacker) <rostedt@goodmis.org>"
> 

gpgv looks at trustedkeys.gpg by default; it's just a different public
keyring.  The *big* difference between gpgv and gpg is that the former
doesn't consult the trustdb *at all*.

	-hpa

