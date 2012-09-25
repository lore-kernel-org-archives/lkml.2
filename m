Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2IYCTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:19:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55721 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2IYCTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:19:49 -0400
X-AuditID: 9c930197-b7b6dae000000e70-17-506114c0ce57
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] perf hists browser: Add option for runtime switching perf data file
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-9-git-send-email-feng.tang@intel.com>
Date: Tue, 25 Sep 2012 11:11:21 +0900
In-Reply-To: <1348500251-9937-9-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Mon, 24 Sep 2012 23:24:10 +0800")
Message-ID: <87d31ayhpy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 23:24:10 +0800, Feng Tang wrote:
[snip]
> +		if (!check_perf_magic(magic)) {
> +			options[nr_options] = strdup(name);
> +			abs_path[nr_options++] = strdup(path);

Need to check return values.


> +		}
> +		fclose(file);
> +	}
> +	closedir(pwd_dir);
> +
> +	if (nr_options) {
> +		choice = ui__popup_menu(nr_options, options);
> +		if (choice < nr_options && choice >= 0) {
> +			input_name = strdup(abs_path[choice]);

Ditto.  Plus it might leak previous input_name.

Thanks,
Namhyung


> +			ret = 0;
> +		}
> +	}
> +
> +	free_popup_options(options, nr_options);
> +	free_popup_options(abs_path, nr_options);
> +	return ret;
> +}
> +
> +
