Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1F2Xmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:42:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46798 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1F2Xma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:42:30 -0400
Subject: Re: [PATCH v7 00/16] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
In-Reply-To: <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <BANLkTinSsqBqX7=jzwbw_=RfXeQz29h_+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 19:42:21 -0400
Message-ID: <1309390941.3205.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 16:53 -0400, Kyle Moffett wrote:
> On Wed, Jun 29, 2011 at 15:50, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
> > protect the integrity of a running system from unauthorized changes. When
> > these protections are not running, such as when booting a malicious OS,
> > mounting the disk under a different operating system, or physically moving
> > the disk to another system, an "offline" attack is free to read and write
> > file data/metadata.
> >
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
> 
> Hmm, I'm not sure that this design actually provides the protection that
> you claim it does.
> 
> Specifically, you don't actually protect the on-disk data-structures that
> are far more vulnerable to malicious modification than the actual *values*
> of the extended attributes themselves.

True, EVM only protects the file metadata. The patch description says,

        While this patchset does authenticate the security xattrs, and
        cryptographically binds them to the inode, coming extensions
        will bind other directory and inode metadata for more complete
        protection.

It should have said, "bind other directory, inode data and inode
metadata."

In particular, IMA-appraisal stores the file data's hash as the
security.ima xattr, which is EVM protected. Other methods, such as
digital signatures, could be used instead of the file's hash, to
additionally provide authenticity.

thanks,

Mimi

