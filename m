Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab0DZVDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:03:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49888 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab0DZVDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:03:33 -0400
Date: Mon, 26 Apr 2010 16:03:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 04/14] evm: re-release
Message-ID: <20100426210333.GB2029@us.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1271886594-3719-5-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271886594-3719-5-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> EVM protects a file's security extended attributes against integrity
> attacks. It maintains an HMAC-sha1 value across the extended attributes,
> storing the value as the extended attribute 'security.evm'. EVM has gone
> through a number of iterations, initially as an LSM module, subsequently
> as a LIM integrity provider, and now, when co-located with a security_
> hook, embedded directly in the security_ hook, similar to IMA.
> 
> This is the first part of a local file integrity verification system.
> While this part does authenticate the selected extended attributes, and
> cryptographically bind them to the inode, coming extensions will bind
> other directory and inode metadata for more complete protection.  The
> set of protected security extended attributes is configured at compile.
> 
> EVM depends on the Kernel Key Retention System to provide it with the
> kernel master key for the HMAC operation.  The kernel master key is
> securely loaded onto the root's keyring, typically by 'loadkernkey',
> which either uses the TPM sealed secret key, if available, or a
> password requested from the console.  To signal EVM, that the key has
> been loaded onto the keyring, 'echo 1 > <securityfs>/evm'. This is
> normally done in the initrd, which has already been measured as part
> of the trusted boot. (Refer to http://linux-ima.sourceforge.net/#EVM.)
> 
> EVM adds the following three calls to the existing security hooks,
> evm_inode_setxattr(), evm_inode_post_setxattr(), and
> evm_inode_removexattr.
> 
> To initialize and update the 'security.evm' extended attribute, EVM
> defines three calls: evm_inode_post_init(), evm_inode_post_setattr()
> and evm_inode_post_removexattr() hooks.
> 
> To verify the integrity of an extended attribute, EVM exports
> evm_verifyxattr().
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge
