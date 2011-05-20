Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935542Ab1ETLV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:21:58 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51541 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203Ab1ETLV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:21:56 -0400
Subject: Re: [PATCH v5 03/21] evm: re-release
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Harald Hoyer <harald.hoyer@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <4DD64CA7.7090307@gmail.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305557115-15652-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110519060543.GA10320@mail.hallyn.com>
	 <1305845343.2528.3.camel@localhost.localdomain>
	 <4DD64CA7.7090307@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 07:21:25 -0400
Message-ID: <1305890485.3247.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 13:12 +0200, Harald Hoyer wrote:
> Am 20.05.2011 00:49, schrieb Mimi Zohar:
> > On Thu, 2011-05-19 at 01:05 -0500, Serge E. Hallyn wrote: 
> >> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> >>> EVM protects a file's security extended attributes(xattrs) against integrity
> >>> attacks.  This patchset provides the framework and an initial method.  The
> >>> initial method maintains an HMAC-sha1 value across the security extended
> >>> attributes, storing the HMAC value as the extended attribute 'security.evm'.
> >>> Other methods of validating the integrity of a file's metadata will be posted
> >>> separately (eg. EVM-digital-signatures).
> >>>
> >>> While this patchset does authenticate the security xattrs, and
> >>> cryptographically binds them to the inode, coming extensions will bind other
> >>> directory and inode metadata for more complete protection.  To help simplify
> >>> the review and upstreaming process, each extension will be posted separately
> >>> (eg. IMA-appraisal, IMA-appraisal-directory).  For a general overview of the
> >>> proposed Linux integrity subsystem, refer to Dave Safford's whitepaper:
> >>> http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf.
> >>>
> >>> EVM depends on the Kernel Key Retention System to provide it with a
> >>> trusted/encrypted key for the HMAC-sha1 operation. The key is loaded onto the
> >>> root's keyring using keyctl.  Until EVM receives notification that the key has
> >>> been successfully loaded onto the keyring (echo 1 > <securityfs>/evm), EVM can
> >>> not create or validate the 'security.evm' xattr, but returns INTEGRITY_UNKNOWN.
> >>> Loading the key and signaling EVM should be done as early as possible. Normally
> >>> this is done in the initramfs, which has already been measured as part of the
> >>> trusted boot.  For more information on creating and loading existing
> >>> trusted/encrypted keys, refer to Documentation/keys-trusted-encrypted.txt.  A
> >>> sample dracut patch, which loads the trusted/encrypted key and enables EVM, is
> >>> available from http://linu-ima.sourceforge.net/#EVM.
> >>
> >> That should read http://linux-ima.sourceforge.net/#EVM.
> > 
> > Thanks for catching that.
> 
> The dracut patch, could easily turned into a separate dracut module with its own
> files, without patching. Somebody did not understand the modular nature of
> dracut. While you are at it, I happily integrate that module in upstream, if you
> submit it to the initramfs mailing list.

thanks!

Mimi

