Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab0FDPUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:20:12 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:38381 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab0FDPUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:20:09 -0400
Subject: Re: [PATCH 04/14] evm: re-release
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1275663212.3205.12.camel@localhost.localdomain>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1271886594-3719-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1275661730.21231.32.camel@moss-pluto.epoch.ncsc.mil>
	 <1275663212.3205.12.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Fri, 04 Jun 2010 11:20:04 -0400
Message-ID: <1275664804.21231.61.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 10:53 -0400, Mimi Zohar wrote:
> On Fri, 2010-06-04 at 10:28 -0400, Stephen Smalley wrote:
> > On Wed, 2010-04-21 at 17:49 -0400, Mimi Zohar wrote:
> > > EVM protects a file's security extended attributes against integrity
> > > attacks. It maintains an HMAC-sha1 value across the extended attributes,
> > > storing the value as the extended attribute 'security.evm'. EVM has gone
> > > through a number of iterations, initially as an LSM module, subsequently
> > > as a LIM integrity provider, and now, when co-located with a security_
> > > hook, embedded directly in the security_ hook, similar to IMA.
> > > 
> > > This is the first part of a local file integrity verification system.
> > > While this part does authenticate the selected extended attributes, and
> > > cryptographically bind them to the inode, coming extensions will bind
> > > other directory and inode metadata for more complete protection.  The
> > > set of protected security extended attributes is configured at compile.
> > > 
> > > EVM depends on the Kernel Key Retention System to provide it with the
> > > kernel master key for the HMAC operation.  The kernel master key is
> > > securely loaded onto the root's keyring, typically by 'loadkernkey',
> > > which either uses the TPM sealed secret key, if available, or a
> > > password requested from the console.  To signal EVM, that the key has
> > > been loaded onto the keyring, 'echo 1 > <securityfs>/evm'. This is
> > > normally done in the initrd, which has already been measured as part
> > > of the trusted boot. (Refer to http://linux-ima.sourceforge.net/#EVM.)
> > 
> > I don't remember this dependency on the kernel key system in prior
> > incarnations of EVM.  Can you explain the rationale for using it, and
> > the implications?
> 
> This changed very early on, so that people without a TPM could 'play'
> with it.

The last time EVM was posted to lsm list (2005, AFAICS) prior to this
year's round, David Safford said:
"Since the kernel master key is unsealed by the hardware TPM only as a
result of a valid trusted boot, and the key is never visible outside the
kernel, the EVM HMAC attribute cannot be forged in an offline attack."

So that seemed to be an important property to you at the time.  I
understand providing alternatives for TPM-less systems, but that doesn't
necessarily mean changing the properties on systems with TPMs.

-- 
Stephen Smalley
National Security Agency

