Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2GRRMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:12:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17948 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2GRRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:12:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6776"; a="209603958"
Message-ID: <5006EE8C.20304@codeaurora.org>
Date: Wed, 18 Jul 2012 10:12:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH] pstore/ftrace: Convert to its own enable/disable debugfs
 knob
References: <20120710001004.GA22744@lizard> <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org> <1342553898.10332.9.camel@gandalf.stny.rr.com> <20120717200130.GA31678@lizard> <1342561102.10332.18.camel@gandalf.stny.rr.com> <20120718034722.GA18081@lizard>
In-Reply-To: <20120718034722.GA18081@lizard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/12 20:47, Anton Vorontsov wrote:
> +
> +	file = debugfs_create_file("record_ftrace", 0600, dir, NULL,
> +				   &pstore_knob_fops);
> +	if (IS_ERR_OR_NULL(file)) {
> +		err = PTR_ERR(file);
> +		pr_err("%s: unable to create pstore/ftrace file: %d\n",
> +		       __func__, err);
> +		goto err_file;
> +	}

debugfs only returns NULL on failure.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

