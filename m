Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2KUUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:09:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60529 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756134Ab2KUUJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:09:25 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18R3NJCcJ8RPIt7eMkKoqKSYcXYjDeFeUVX0FKTFc
	1U8k6oo+NFyUuJ
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v4] TPM: Issue TPM_STARTUP at driver load if the TPM has not been started
Date: Wed, 21 Nov 2012 21:17:54 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.7; KDE/4.8.5; x86_64; ; )
Cc: Peter.Huewe@infineon.com, key@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
References: <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com> <74A44 <20121121183713.GA12822@obsidianresearch.com>
In-Reply-To: <20121121183713.GA12822@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211212117.55040.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Thanks for the updated patch! 
Sorry, I have one really minor remark left:

> +	if (rc) {
> +		dev_err(chip->dev,
> +			"A TPM error (%d) occurred attempting to determine the timeouts\n",

rc is a ssize_t here and when compiling with C=1 I get
drivers/char/tpm/tpm.c:582:4: warning: format '%d' expects argument of type 'int', but argument 3 has type 'ssize_t' [-Wformat]

Care to change to 
> +			"A TPM error (%zd) occurred attempting to determine the timeouts\n",

Sorry that I didn't spot it earlier.


Thanks,
Peter

