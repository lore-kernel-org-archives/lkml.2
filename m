Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2CWNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 09:25:59 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:36663 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2CWNZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 09:25:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120322212816.GB30888@kroah.com>
References: <CAEwYmTJzzUi1qfRHYfZg77g1K7myNsAh2oDiY7hWxzRO5hQGHA@mail.gmail.com>
	<20120322212816.GB30888@kroah.com>
Date: Fri, 23 Mar 2012 09:25:54 -0400
Message-ID: <CAEwYmT+K7qr94D+ef1hgG1A2u0a9z+sopBjm08N2DcxM1FrM1w@mail.gmail.com>
Subject: Re: sysfs binary attribute API flux
From: Jonathan McCune <jonmccune@cmu.edu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, FROM_EDU_TLD 0, WEBMAIL_SOURCE 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HELO_GMAIL 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_HTTP_RECEIVED 0, __PHISH_SPEAR_STRUCTURE_1 0, __PHISH_SPEAR_STRUCTURE_2 0, __RDNS_GMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 5:28 PM, Greg KH <greg@kroah.com> wrote:
>> necessary to move some binary data from userspace into the kernel.
> What exact type of binary data are you talking about here?

There is a statically linked executable, which will also take a binary
blob as input, and produce another as output.

>> have been using sysfs's 'struct bin_attribute'.  Unfortunately, every
>> few kernel versions, my code breaks because of a change in the
>> definition of some elements in this struct.  For example, kernel
>
> Is this a problem?  It's only an issue for code that lives outside of
> the kernel, and there's nothing we can do about that, sorry.

My main question is one about best practices.  If using sysfs and
keeping up with such changes is the best option available, I can live
with that.  However, if I've somehow missed a preferred alternative,
then I would like to use it.

> debugfs?

This may be an option, but my understanding is that it makes even
fewer promises about API stability.

> What exactly are you using this data for?  Who creates it?  What does it
> represent?

The research project involves using Intel TXT (or the AMD SVM
equivalent) as a form of context switch mechanism to execute the
statically-linked binary code in isolation from the rest of the
system.  Thus, there's some amount of systems-level code (executes in
ring 0) in the binary to preserve the state of the Linux kernel, but
the majority of it performs some kind of application-specific
(executes in ring 3) function (e.g., protects some SSL / SSH / VPN
keys). Another way to think about it is as a provision for arbitrarily
many virtual smart cards, e.g., from userspace this shouldn't look all
that different from loading binary code into some kind of peripheral
device with support for arbitrary execution. In case you're interested
in the code or the research paper describing the approach in more
detail:

http://flickertcb.sourceforge.net/

http://www.ece.cmu.edu/~jmmccune/papers/mccune_parno_perrig_reiter_isozaki_eurosys08.pdf

Many thanks for your time,
-Jon
