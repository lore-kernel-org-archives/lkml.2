Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1ESA0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:26:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab1ESA0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:26:03 -0400
Date: Wed, 18 May 2011 17:25:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
Message-Id: <20110518172552.6d482c7a.akpm@linux-foundation.org>
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011 10:44:54 -0400
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Extended Verification Module(EVM) detects offline tampering of the security
> extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
> which is the basis for LSM permission decisions and, with the IMA-appraisal
> patchset, integrity appraisal decisions. This patchset provides the framework
> and an initial method to detect offline tampering of the security extended
> attributes.  The initial method maintains an HMAC-sha1 across a set of
> security extended attributes, storing the HMAC as the extended attribute
> 'security.evm'. To verify the integrity of an extended attribute, EVM exports
> evm_verifyxattr(), which re-calculates the HMAC and compares it with the
> version stored in 'security.evm'.  Other methods of validating the integrity
> of a file's metadata will be posted separately (eg. EVM-digital-signatures).
> 
> While this patchset does authenticate the security xattrs, and
> cryptographically binds them to the inode, coming extensions will bind other
> directory and inode metadata for more complete protection.  To help simplify
> the review and upstreaming process, each extension will be posted separately
> (eg. IMA-appraisal, IMA-appraisal-directory).  For a general overview of the
> proposed Linux integrity subsystem, refer to Dave Safford's whitepaper:
> http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf.
> 
> Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
> reviewing the original patches.

The changelog forgot to define "offline tampering".  I can guess what
it means, but my guess will surely be incomplete.  I can do a web
search for the term but that really only leads me to this patchset.

It would be much better if I didn't have to guess.  A good description
would list all the known offline tampering scenarios and would explain
how the patchset addresses them and whether there are any scenarios
which are not addressed.

Secondly, the changelog didn't attempt to give anyone a reason to merge
the patchset.  Why is offline tampering bad?  Why should we bother
addressing it?  What value does this patchset provide to our users? 
Again, I could guess.  But it would be much much better to have these
things explained to us by the people who understand them.

Thirdly, I'm not seeing a description of the user interface anywhere. 
Please fully describe it in a manner which can be efficiently reviewed.
For example, if there are any user-provided inputs, describe them.  If
tampering has been detected then this is presumably communicated to the
operator in some fashion.  Please fully describe that reporting scheme.
What steps do we expect the operator to take after tampering has been
detected?  How does the patchset aid them in that?  etc.


Once we have a better understanding of what the feature does and why it
does it and how it interfaces with the user, we can start looking at
the implementation.

