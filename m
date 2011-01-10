Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1AJIK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:10:59 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48869 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab1AJIK6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:10:58 -0500
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Jesper Juhl <jj@chaosbits.net>,
        DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>
CC: "Moore, Eric" <Eric.Moore@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support, Software" <support@lsi.com>
Date: Mon, 10 Jan 2011 13:41:28 +0530
Subject: RE: [PATCH] SCSI, LSI Fusion MPT: Fix memory leak in
 mptctl_getiocinfo()
Thread-Topic: [PATCH] SCSI, LSI Fusion MPT: Fix memory leak in
 mptctl_getiocinfo()
Thread-Index: AculQz/lCNQ9PQ54Tb6wKWuskXHyyQLWqUwA
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70916AAA4@inbmail01.lsi.com>
References: <alpine.LNX.2.00.1012262207380.20797@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012262207380.20797@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper, Your finding is correct.

Please consider this patch as an ACKed by me.

~ Kashyap


> -----Original Message-----
> From: Jesper Juhl [mailto:jj@chaosbits.net]
> Sent: Monday, December 27, 2010 2:44 AM
> To: DL-MPT Fusion Linux
> Cc: Moore, Eric; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Support, Software
> Subject: [PATCH] SCSI, LSI Fusion MPT: Fix memory leak in
> mptctl_getiocinfo()
> 
> Hi,
> 
> A 'kfree(karg)' is missing in a failure path in
> drivers/message/fusion/mptctl.c::mptctl_getiocinfo() which can cause a
> memory leak. This patch should take care of that.
> 
> Hope I didn't miss something obvious, but to me it looks like adding
> this
> kfree() is the right thing to do. If you disagree feel free to correct
> me
> :-)
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  mptctl.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
>   compile tested only since I don't have proper hardware to test for
> real.
> 
> diff --git a/drivers/message/fusion/mptctl.c
> b/drivers/message/fusion/mptctl.c
> index a3856ed..1dcc13a 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1307,8 +1307,10 @@ mptctl_getiocinfo (unsigned long arg, unsigned
> int data_size)
>  	else
>  		karg->adapterType = MPT_IOCTL_INTERFACE_SCSI;
> 
> -	if (karg->hdr.port > 1)
> +	if (karg->hdr.port > 1) {
> +		kfree(karg);
>  		return -EINVAL;
> +	}
>  	port = karg->hdr.port;
> 
>  	karg->port = port;
> 
> 
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.

