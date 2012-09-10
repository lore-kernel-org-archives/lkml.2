Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2IJKXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:23:00 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63327 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533Ab2IJKW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:22:56 -0400
Message-ID: <504DBF3D.2000102@mvista.com>
Date: Mon, 10 Sep 2012 14:21:49 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Xie Shaohui-B21989 <B21989@freescale.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bhartiya Anju-B07263 <B07263@freescale.com>
Subject: Re: [PATCH][v3] sata_fsl: add workaround for data length mismatch
 on freescale V2 controller
References: <1347012095-4404-1-git-send-email-Shaohui.Xie@freescale.com> <82046C25-828E-4E0F-9F86-8E038AE5C93C@kernel.crashing.org> <ED492CCEAF882048BC2237DE806547C9079D9AB9@039-SN2MPN1-012.039d.mgd.msft.net>
In-Reply-To: <ED492CCEAF882048BC2237DE806547C9079D9AB9@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-09-2012 6:53, Xie Shaohui-B21989 wrote:

>>> +	/* Workaround for data length mismatch errata */
>>> +	if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
>>> +		for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
>>> +			qc = ata_qc_from_tag(ap, tag);
>>> +			if (qc && ata_is_atapi(qc->tf.protocol)) {
>>> +				u32 hcontrol;
>>> +#define HCONTROL_CLEAR_ERROR	(1 << 27)

>> shouldn't we have this #define be part of the enum that the other
>> HCONTROL_ bits/flags are part of?

> [S.H] do you mean this?

    Apparently not. He said *enum*, not #define.

> #ifdef SATA_FSL_XXX_ERRATUAM

    We don't need that at all.

> #define HCONTROL_CLEAR_ERROR	(1 << 27)
> #endif

MBR, Sergei

