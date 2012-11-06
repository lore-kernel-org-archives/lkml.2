Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2KFUzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:55:51 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62635 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2KFUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:55:49 -0500
Message-ID: <50997955.10000@gmail.com>
Date: Tue, 06 Nov 2012 15:55:49 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>  <1352145183-29355-3-git-send-email-xi.wang@gmail.com> <1352203618.2529.22.camel@dabdike>
In-Reply-To: <1352203618.2529.22.camel@dabdike>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/12 7:06 AM, James Bottomley wrote:
>
> Why is this necessary?  As I read the reg set assignment code, it finds
> a free bit in the 64 bit register and uses that ... which can never be
> greater than 64 so there's no need for the check.

This patch just tries to be more defensive for bit(reg_set) with a
broken reg_set value.  I agree with you that it's not that necessary.

> The other two look OK (probably redone as a single patch with a stable
> tag), but I'd like the input of the mvs people since it seems with the
> current code, we only use 32 bit regsets and probably hang if we go over
> that.  The bug fix is either to enable the full 64 if it works, or
> possibly cap at 32 ... what works with all released devices?

Thanks for reviewing.  Yeah we'd better to wait for the input from
the mvs people.

- xi
