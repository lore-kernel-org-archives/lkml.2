Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2JAJRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:17:32 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:18066 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab2JAJRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:17:31 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jgunthorpe@obsidianresearch.com>, <linux-kernel@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>
Subject: RE: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Thread-Topic: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Thread-Index: AQHNn2pdOsnXAeayo0enYmQRsgYYcpekKczg
Date: Mon, 1 Oct 2012 09:17:28 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
References: <20120930233012.GH30637@obsidianresearch.com>
In-Reply-To: <20120930233012.GH30637@obsidianresearch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

> The TPM will respond to TPM_GET_CAP with TPM_ERR_INVALID_POSTINIT if
> TPM_STARTUP has not been issued. This will result in the TPM driver
> failing to load and no way to recover. Detect this and automatically
> issue TPM_STARTUP.

> This is for embedded applications where the kernel is the first thing
> to touch the TPM.

Thanks for working on this.
I also thought about this scenario quite often.

Shouldn't we then also add a TpmStartup(ST_STATE) in case of a resume?
 rc=GetCapability()
 if(rc==INVALID_POSTINIT)
 	tpm_transmit ("TPM_STARTUP(ST_STATE)")...

Thanks,
Peter
