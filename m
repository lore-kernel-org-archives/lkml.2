Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1BKH77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:59:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab1BKH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:59:58 -0500
Date: Thu, 10 Feb 2011 23:59:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        Stefan Berger <stefanb@us.ibm.com>,
        Guillaume Chazarain <guichaz@gmail.com>
Subject: Re: [GIT PULL] TPM timeout fix
Message-Id: <20110210235919.f9ef09b5.akpm@linux-foundation.org>
In-Reply-To: <4D54B688.4010307@linux.vnet.ibm.com>
References: <4D54B688.4010307@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 02:09:44 -0200 Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:

> Hi James,
> 
> Please pull from:
>      git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james
> 
> The following change corrects the logic used to extract the timeouts returned from a TPM.
> These values are used subsequently in the TPM device driver, and if relying on the default values,
> some commands may not have its proper timeout considered. This is a bugfix for the current linus tree.
> 
> Stefan Berger (1):
>        tpm_tis: Use timeouts returned from TPM
> 
> Diffstat:
>   drivers/char/tpm/tpm.c     |   18 ++++++++++++++++--
>   drivers/char/tpm/tpm.h     |    2 ++
>   drivers/char/tpm/tpm_tis.c |    4 +++-
>   3 files changed, 21 insertions(+), 3 deletions(-)

Please include the full patch in the email unless it's huge, so others
don't need to jump through hoops to see the change.

Is this bug present in 2.6.37 and earlier?  If so, should we fix it in
those kernels?

<finds "tpm_tis: Use timeouts returned from TPM" on the mailing list>

OK, earlier kernels do need fixing.  Hopefully you included
"Cc: <stable@kernel.org>" in the changelog which we weren't shown.

That patch adds a new sysfs file but doesn't alter any documentation
file for it.

