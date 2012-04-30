Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2D3JR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:17:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61094 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2D3JR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:17:56 -0400
Date: Mon, 30 Apr 2012 11:17:49 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        Chiwoong byun <woong.byun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] MFD : add MAX77686 mfd driver
Message-ID: <20120430091748.GA2460@andi>
Mail-Followup-To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
	sameo@linux.intel.com, linux-kernel@vger.kernel.org,
	cw00.choi@samsung.com, Chiwoong byun <woong.byun@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>
References: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +	mutex_lock(&max77686->iolock);
> +	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
> +	mutex_unlock(&max77686->iolock);

Is it relly necessay to lock whenever you read/write from/to the
i2c bus? Considering also that these are exported function,
someone else may lock here before, so we can have a double
locking on the same mutex.

Andi
