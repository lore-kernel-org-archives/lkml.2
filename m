Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1FBWiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:38:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1FBWiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:38:07 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=wom5GMh1gUkA:10 a=-aXJkhsTUggA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=VnNF1IyMAAAA:8 a=2z1OXlWFAAAA:8 a=DfNHnWVPAAAA:8 a=LoNo02exYwrPBwHLqloA:9 a=ls6jA5zJLO357-XQHSwA:7 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 2 Jun 2011 17:38:03 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v6 03/20] evm: re-release
Message-ID: <20110602223803.GA23700@mail.hallyn.com>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1307017423-15093-4-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307017423-15093-4-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> EVM protects a file's security extended attributes(xattrs) against integrity
> attacks.  This patchset provides the framework and an initial method.  The
> initial method maintains an HMAC-sha1 value across the security extended
> attributes, storing the HMAC value as the extended attribute 'security.evm'.
> Other methods of validating the integrity of a file's metadata will be posted
> separately (eg. EVM-digital-signatures).
> 
> While this patchset does authenticate the security xattrs, and
> cryptographically binds them to the inode, coming extensions will bind other
> directory and inode metadata for more complete protection.  To help simplify
> the review and upstreaming process, each extension will be posted separately
> (eg. IMA-appraisal, IMA-appraisal-directory).  For a general overview of the
> proposed Linux integrity subsystem, refer to Dave Safford's whitepaper:
> http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf.
> 
> EVM depends on the Kernel Key Retention System to provide it with a
> trusted/encrypted key for the HMAC-sha1 operation. The key is loaded onto the
> root's keyring using keyctl.  Until EVM receives notification that the key has
> been successfully loaded onto the keyring (echo 1 > <securityfs>/evm), EVM can
> not create or validate the 'security.evm' xattr, but returns INTEGRITY_UNKNOWN.
> Loading the key and signaling EVM should be done as early as possible. Normally
> this is done in the initramfs, which has already been measured as part of the
> trusted boot.  For more information on creating and loading existing
> trusted/encrypted keys, refer to Documentation/keys-trusted-encrypted.txt.
> 
> Based on the LSMs enabled, the set of EVM protected security xattrs is defined
> at compile.  EVM adds the following three calls to the existing security hooks:
> evm_inode_setxattr(), evm_inode_post_setxattr(), and evm_inode_removexattr.  To
> initialize and update the 'security.evm' extended attribute, EVM defines three
> calls: evm_inode_post_init(), evm_inode_post_setattr() and
> evm_inode_post_removexattr() hooks.  To verify the integrity of a security
> xattr, EVM exports evm_verifyxattr().
> 
> Changelog v6: (based on Serge Hallyn's review)
> - fix URL in patch description

It's still wrong in Documentation/ABI/testing/evm...

> - remove evm_hmac_size definition
> - use SHA1_DIGEST_SIZE (removed both MAX_DIGEST_SIZE and evm_hmac_size)
> - moved linux include before other includes
> - test for crypto_hash_setkey failure
> - fail earlier for invalid key
> - clear entire encrypted key, even on failure
> - check xattr name length before comparing xattr names

The rest looks good, thanks

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

-serge
