Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab2GESAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:00:43 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:44538 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2GESAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:00:42 -0400
Date: Thu, 5 Jul 2012 21:00:34 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/19] Staging: xgifb: Rework conditions in
 XGI_SetLockRegs().
Message-ID: <20120705180034.GC4519@blackmetal.musicnaut.iki.fi>
References: <cover.1341498465.git.magomez@igalia.com>
 <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 05, 2012 at 04:45:58PM +0200, Miguel Gómez wrote:
> +		if ((pVBInfo->VBType & VB_SIS301LV) &&
> +		    !(pVBInfo->TVInfo & TVSetHiVision)) {
> +			if ((pVBInfo->TVInfo & TVSimuMode) &&
> +			    (pVBInfo->TVInfo & TVSetPAL)) {
> +				if (pVBInfo->VBType & VB_SIS301LV) {
> +					if (!(pVBInfo->TVInfo &
> +					      (TVSetYPbPr525p |
> +					       TVSetYPbPr750p |
> +					       TVSetHiVision)))
> +						tempbx += 40;
> +				} else {
> +					tempbx += 40;

I think this could be simplified even more - both branches end up doing
the same?!

A.
