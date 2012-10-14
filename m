Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2JNDih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 23:38:37 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:49597 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2JNDig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 23:38:36 -0400
Date: Sun, 14 Oct 2012 05:38:35 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: npiggin@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] brd: Add miscdevice to control creation and deletion of ramdisks
Message-ID: <20121014033835.GA30463@order.stressinduktion.org>
Mail-Followup-To: npiggin@kernel.dk, linux-kernel@vger.kernel.org
References: <20121014024836.GB27966@order.stressinduktion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121014024836.GB27966@order.stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 04:48:36AM +0200, Hannes Frederic Sowa wrote:
> +	case BRD_CTL_DEL:
> +		error = get_user(val, (int __user *)param);
> +		if (error < 0)
> +			break;
> +		if ((val & max_part) != 0) {
> +			error = -EINVAL;
> +			break;
> +		}
> +		val >>= part_shift;
> +		brd2 = NULL;
> +		list_for_each_entry(brd, &brd_devices, brd_list) {
> +			if (brd->brd_number == val) {
> +				brd2 = brd;
> +				break;
> +			}
> +		}
> +		if (brd2 == NULL) {
> +			error = -ENODEV;
> +			break;
> +		}
> +		brd_del_one(brd2);
> +		break;

Sorry, first bug spotted. I should check the bd_openers before destroying the
device. Will be fixed in a follow-up patch, if needed.

