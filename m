Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0KBL1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 07:27:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47968 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0KBL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 07:27:06 -0400
Subject: Re: [PATCH 1/3] evm: added flag IMA_NEW in the
 integrity_iint_cache structure
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <201011021105.55746.roberto.sassu@polito.it>
References: <201011021105.55746.roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 07:27:02 -0400
Message-ID: <1288697222.16939.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 11:05 +0100, Roberto Sassu wrote:
> The flag IMA_NEW is set in the function evm_inode_post_init_security()
> to distinguish between new and existent files and it is cleared in the
> function ima_dec_counts(). This permits to check/fix the 'security.ima'
> extended attribute properly in the function ima_appraise_measurement()
> without verifying the 'version' field of the 'integrity_iint_cache'
> structure.
> The 'i_version' field of the inode is not suitable for determining if a
> file is being created because the value '1' may be assumed by inodes
> already in the filesystem before mounting the same with the parameter
> 'iversion' as well as those newly created.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Hi Roberto.  Yes, the current patches are not differentiating an
existing file from a new one properly. I think it can be done by
replacing the 'inode->iversion == 1' test in ima_appraise_measurement()
with a test for 'inode->i_size == 0', without adding an xattr.
.
thanks,

Mimi

