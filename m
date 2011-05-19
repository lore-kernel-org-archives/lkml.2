Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1ESBvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:51:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55242 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1ESBvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:51:46 -0400
Subject: Re: [PATCH v5 00/21] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
In-Reply-To: <20110518172552.6d482c7a.akpm@linux-foundation.org>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110518172552.6d482c7a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 21:51:30 -0400
Message-ID: <1305769890.3304.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 17:25 -0700, Andrew Morton wrote:
> On Mon, 16 May 2011 10:44:54 -0400
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Extended Verification Module(EVM) detects offline tampering of the security
> > extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
> > which is the basis for LSM permission decisions and, with the IMA-appraisal
> > patchset, integrity appraisal decisions. This patchset provides the framework
> > and an initial method to detect offline tampering of the security extended
> > attributes.  The initial method maintains an HMAC-sha1 across a set of
> > security extended attributes, storing the HMAC as the extended attribute
> > 'security.evm'. To verify the integrity of an extended attribute, EVM exports
> > evm_verifyxattr(), which re-calculates the HMAC and compares it with the
> > version stored in 'security.evm'.  Other methods of validating the integrity
> > of a file's metadata will be posted separately (eg. EVM-digital-signatures).
> > 
> > While this patchset does authenticate the security xattrs, and
> > cryptographically binds them to the inode, coming extensions will bind other
> > directory and inode metadata for more complete protection.  To help simplify
> > the review and upstreaming process, each extension will be posted separately
> > (eg. IMA-appraisal, IMA-appraisal-directory).  For a general overview of the
> > proposed Linux integrity subsystem, refer to Dave Safford's whitepaper:
> > http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf.
> > 
> > Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
> > reviewing the original patches.
> 
> The changelog forgot to define "offline tampering".  I can guess what
> it means, but my guess will surely be incomplete.  I can do a web
> search for the term but that really only leads me to this patchset.
> 
> It would be much better if I didn't have to guess.  A good description
> would list all the known offline tampering scenarios and would explain
> how the patchset addresses them and whether there are any scenarios
> which are not addressed.

ok.

> Secondly, the changelog didn't attempt to give anyone a reason to merge
> the patchset.  Why is offline tampering bad?  Why should we bother
> addressing it?  What value does this patchset provide to our users? 
> Again, I could guess.  But it would be much much better to have these
> things explained to us by the people who understand them.

Perhaps posting the EVM patches separately from the IMA-appraisal patches
wasn't the best idea after all, at least in terms of the patch description.
Previously, the combined EVM/IMA-appraisal patchset continued with:

IMA currently maintains an integrity measurement list, containing the hashes
of all executables, mmapped execute files, and files open for read by root
(assuming the default measurement policy). The measurement list, with other
information, can be used to assert the integrity of the running system to a
third party. This patchset extends IMA with local measurement appraisal. The
extension stores and maintains the file integrity measurement as an extended
attribute 'security.ima', which EVM can be configured to protect. Other
methods of validating a file's integrity will be posted as a separate
patchset (eg. IMA-digital-signatures).

DAC/MAC protect the integrity of a running system.  An offline attack can
bypass these protection mechanisms by mounting the disk under a different
operating system and modifying the file data/metadata.  If the disk is
subsequently remounted under the EVM + DAC/MAC + IMA protected OS, then the
hash of the file data won't match the hash stored in the IMA xattr, or the
TPM-calculated HMAC of the file's metadata won't be valid.  Therefore, IMA +
MAC + EVM can protect system integrity online and detect offline tampering.

> Thirdly, I'm not seeing a description of the user interface anywhere. 
> Please fully describe it in a manner which can be efficiently reviewed.
> For example, if there are any user-provided inputs, describe them.  If
> tampering has been detected then this is presumably communicated to the
> operator in some fashion.  Please fully describe that reporting scheme.
> What steps do we expect the operator to take after tampering has been
> detected?  How does the patchset aid them in that?  etc.

There aren't any userspace utilities to speak of, except for labeling
the filesystem.  EVM/IMA-appraisal is in addition to the existing
mandatory/discretionary access controls. The EVM/IMA-appraisal decision
is based on file data and metadata integrity.

> Once we have a better understanding of what the feature does and why it
> does it and how it interfaces with the user, we can start looking at
> the implementation.

Much appreciated!

thanks,

Mimi

