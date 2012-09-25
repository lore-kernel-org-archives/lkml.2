Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2IYI12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:27:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:43413 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab2IYI1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:27:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,479,1344236400"; 
   d="scan'208";a="197337471"
Date: Tue, 25 Sep 2012 16:20:53 +0800
From: Feng Tang <feng.tang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <andi@firstfloor.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/9] perf hists browser: Add option for runtime
 switching perf data file
Message-ID: <20120925162053.51f60773@feng-i7>
In-Reply-To: <87d31ayhpy.fsf@sejong.aot.lge.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-9-git-send-email-feng.tang@intel.com>
	<87d31ayhpy.fsf@sejong.aot.lge.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 11:11:21 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> On Mon, 24 Sep 2012 23:24:10 +0800, Feng Tang wrote:
> [snip]
> > +		if (!check_perf_magic(magic)) {
> > +			options[nr_options] = strdup(name);
> > +			abs_path[nr_options++] = strdup(path);
> 
> Need to check return values.
> 
> 
> > +		}
> > +		fclose(file);
> > +	}
> > +	closedir(pwd_dir);
> > +
> > +	if (nr_options) {
> > +		choice = ui__popup_menu(nr_options, options);
> > +		if (choice < nr_options && choice >= 0) {
> > +			input_name = strdup(abs_path[choice]);
> 
> Ditto.  Plus it might leak previous input_name.

Nice catch, will check the return value of "strdup". 

For input_name mem leak, in some cases the input_name can't be called
 with free(), like those got from parse "-i" option. In case the old
input_name is got from malloc through strdup, I think it's not a big
issue given that buffer will be freed any way when the application exit.

Thanks,
Feng

> 
> Thanks,
> Namhyung
> 
> 
> > +			ret = 0;
> > +		}
> > +	}
> > +
> > +	free_popup_options(options, nr_options);
> > +	free_popup_options(abs_path, nr_options);
> > +	return ret;
> > +}
> > +
> > +
