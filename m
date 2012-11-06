Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab2KFMHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:07:03 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55484 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888Ab2KFMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:07:02 -0500
Message-ID: <1352203618.2529.22.camel@dabdike>
Subject: Re: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 06 Nov 2012 13:06:58 +0100
In-Reply-To: <1352145183-29355-3-git-send-email-xi.wang@gmail.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
	 <1352145183-29355-3-git-send-email-xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 14:53 -0500, Xi Wang wrote:
> Invoking bit(n) with n >= 64 is undefined behavior, since bit(n) does
> a 64-bit shift.  This patch adds a check on the shifting amount.

Why is this necessary?  As I read the reg set assignment code, it finds
a free bit in the 64 bit register and uses that ... which can never be
greater than 64 so there's no need for the check.

The other two look OK (probably redone as a single patch with a stable
tag), but I'd like the input of the mvs people since it seems with the
current code, we only use 32 bit regsets and probably hang if we go over
that.  The bug fix is either to enable the full 64 if it works, or
possibly cap at 32 ... what works with all released devices?

James


