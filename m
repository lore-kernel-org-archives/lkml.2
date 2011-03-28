Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1C1SLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:11:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47332 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754697Ab1C1SLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:11:45 -0400
Date: Mon, 28 Mar 2011 19:11:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: Remove possible deadlock from
 regulator_enable
Message-ID: <20110328181151.GB28494@opensource.wolfsonmicro.com>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
 <1301326482-6547-2-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301326482-6547-2-git-send-email-collinsd@codeaurora.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 08:34:41AM -0700, David Collins wrote:

Review curtailed by me having to dash off but one comment...

> -/* locks held by regulator_enable() */
> +/* Locks are *not* held by regulator_enable(). */
>  static int _regulator_enable(struct regulator_dev *rdev)
>  {
> -	int ret, delay;
> +	struct regulator_dev *supply_rdev = NULL;
> +	int ret = 0, delay;
>  
> +	mutex_lock(&rdev->mutex);

This is going to be terribly confusing - the _ versions of the functions
all by convention rely on their callers taking the mutex, allowing them
to be safely used from internal APIs.  
