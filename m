Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab2CZSQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:16:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56316 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab2CZSQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:16:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6661"; a="175886508"
Message-ID: <4F70B261.7060402@codeaurora.org>
Date: Mon, 26 Mar 2012 11:16:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 6/6] PM / Sleep: Mitigate race between the freezer and
 request_firmware()
References: <201203032122.36745.chunkeey@googlemail.com> <201203200000.43316.rjw@sisk.pl> <201203260000.34377.rjw@sisk.pl> <201203260004.55956.rjw@sisk.pl>
In-Reply-To: <201203260004.55956.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/12 15:04, Rafael J. Wysocki wrote:
> Index: linux/kernel/power/process.c
> ===================================================================
> --- linux.orig/kernel/power/process.c
> +++ linux/kernel/power/process.c
> @@ -135,6 +135,7 @@ int freeze_processes(void)
>  	error = try_to_freeze_tasks(true);
>  	if (!error) {
>  		printk("done.");
> +		__usermodehelper_reset(UMH_DISABLED);
>  		oom_killer_disable();
>  	}
>  	printk("\n");

nitpick: This doesn't seem to be doing a reset, more like a set. Perhaps
this function should be called __usermodehelper_set()?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

