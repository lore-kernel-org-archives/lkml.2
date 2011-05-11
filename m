Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab1EKQpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:45:11 -0400
Received: from void.printf.net ([89.145.121.20]:52752 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab1EKQpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:45:08 -0400
From: Chris Ball <cjb@laptop.org>
To: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCHv1] mmc_test: minor clean up, use t = &test.area everywhere
References: <be7436a045a4706e31660c92bb8f48cd043facfc.1305030615.git.ext-andriy.shevchenko@nokia.com>
Date: Wed, 11 May 2011 00:07:19 -0400
In-Reply-To: <be7436a045a4706e31660c92bb8f48cd043facfc.1305030615.git.ext-andriy.shevchenko@nokia.com>
	(Andy Shevchenko's message of "Tue, 10 May 2011 15:59:01 +0300")
Message-ID: <m3tyd13mo8.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, (adding Adrian to CC)

On Tue, May 10 2011, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> ---
>  drivers/mmc/card/mmc_test.c |   75 +++++++++++++++++++++++++------------------
>  1 files changed, 44 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> index 35252c1..233cdfa 100644
> --- a/drivers/mmc/card/mmc_test.c
> +++ b/drivers/mmc/card/mmc_test.c
> @@ -1386,8 +1386,9 @@ static int mmc_test_area_io(struct mmc_test_card *test, unsigned long sz,
>   */
>  static int mmc_test_area_fill(struct mmc_test_card *test)
>  {
> -	return mmc_test_area_io(test, test->area.max_tfr, test->area.dev_addr,
> -				1, 0, 0);
> +	struct mmc_test_area *t = &test->area;
> +
> +	return mmc_test_area_io(test, t->max_tfr, t->dev_addr, 1, 0, 0);
>  }
>  
>  /*
> @@ -1400,7 +1401,7 @@ static int mmc_test_area_erase(struct mmc_test_card *test)
>  	if (!mmc_can_erase(test->card))
>  		return 0;
>  
> -	return mmc_erase(test->card, t->dev_addr, test->area.max_sz >> 9,
> +	return mmc_erase(test->card, t->dev_addr, t->max_sz >> 9,
>  			 MMC_ERASE_ARG);
>  }
>  
> @@ -1527,8 +1528,10 @@ static int mmc_test_area_prepare_fill(struct mmc_test_card *test)
>  static int mmc_test_best_performance(struct mmc_test_card *test, int write,
>  				     int max_scatter)
>  {
> -	return mmc_test_area_io(test, test->area.max_tfr, test->area.dev_addr,
> -				write, max_scatter, 1);
> +	struct mmc_test_area *t = &test->area;
> +
> +	return mmc_test_area_io(test, t->max_tfr, t->dev_addr, write,
> +				max_scatter, 1);
>  }
>  
>  /*
> @@ -1568,18 +1571,19 @@ static int mmc_test_best_write_perf_max_scatter(struct mmc_test_card *test)
>   */
>  static int mmc_test_profile_read_perf(struct mmc_test_card *test)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned long sz;
>  	unsigned int dev_addr;
>  	int ret;
>  
> -	for (sz = 512; sz < test->area.max_tfr; sz <<= 1) {
> -		dev_addr = test->area.dev_addr + (sz >> 9);
> +	for (sz = 512; sz < t->max_tfr; sz <<= 1) {
> +		dev_addr = t->dev_addr + (sz >> 9);
>  		ret = mmc_test_area_io(test, sz, dev_addr, 0, 0, 1);
>  		if (ret)
>  			return ret;
>  	}
> -	sz = test->area.max_tfr;
> -	dev_addr = test->area.dev_addr;
> +	sz = t->max_tfr;
> +	dev_addr = t->dev_addr;
>  	return mmc_test_area_io(test, sz, dev_addr, 0, 0, 1);
>  }
>  
> @@ -1588,6 +1592,7 @@ static int mmc_test_profile_read_perf(struct mmc_test_card *test)
>   */
>  static int mmc_test_profile_write_perf(struct mmc_test_card *test)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned long sz;
>  	unsigned int dev_addr;
>  	int ret;
> @@ -1595,8 +1600,8 @@ static int mmc_test_profile_write_perf(struct mmc_test_card *test)
>  	ret = mmc_test_area_erase(test);
>  	if (ret)
>  		return ret;
> -	for (sz = 512; sz < test->area.max_tfr; sz <<= 1) {
> -		dev_addr = test->area.dev_addr + (sz >> 9);
> +	for (sz = 512; sz < t->max_tfr; sz <<= 1) {
> +		dev_addr = t->dev_addr + (sz >> 9);
>  		ret = mmc_test_area_io(test, sz, dev_addr, 1, 0, 1);
>  		if (ret)
>  			return ret;
> @@ -1604,8 +1609,8 @@ static int mmc_test_profile_write_perf(struct mmc_test_card *test)
>  	ret = mmc_test_area_erase(test);
>  	if (ret)
>  		return ret;
> -	sz = test->area.max_tfr;
> -	dev_addr = test->area.dev_addr;
> +	sz = t->max_tfr;
> +	dev_addr = t->dev_addr;
>  	return mmc_test_area_io(test, sz, dev_addr, 1, 0, 1);
>  }
>  
> @@ -1614,6 +1619,7 @@ static int mmc_test_profile_write_perf(struct mmc_test_card *test)
>   */
>  static int mmc_test_profile_trim_perf(struct mmc_test_card *test)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned long sz;
>  	unsigned int dev_addr;
>  	struct timespec ts1, ts2;
> @@ -1625,8 +1631,8 @@ static int mmc_test_profile_trim_perf(struct mmc_test_card *test)
>  	if (!mmc_can_erase(test->card))
>  		return RESULT_UNSUP_HOST;
>  
> -	for (sz = 512; sz < test->area.max_sz; sz <<= 1) {
> -		dev_addr = test->area.dev_addr + (sz >> 9);
> +	for (sz = 512; sz < t->max_sz; sz <<= 1) {
> +		dev_addr = t->dev_addr + (sz >> 9);
>  		getnstimeofday(&ts1);
>  		ret = mmc_erase(test->card, dev_addr, sz >> 9, MMC_TRIM_ARG);
>  		if (ret)
> @@ -1634,7 +1640,7 @@ static int mmc_test_profile_trim_perf(struct mmc_test_card *test)
>  		getnstimeofday(&ts2);
>  		mmc_test_print_rate(test, sz, &ts1, &ts2);
>  	}
> -	dev_addr = test->area.dev_addr;
> +	dev_addr = t->dev_addr;
>  	getnstimeofday(&ts1);
>  	ret = mmc_erase(test->card, dev_addr, sz >> 9, MMC_TRIM_ARG);
>  	if (ret)
> @@ -1646,12 +1652,13 @@ static int mmc_test_profile_trim_perf(struct mmc_test_card *test)
>  
>  static int mmc_test_seq_read_perf(struct mmc_test_card *test, unsigned long sz)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned int dev_addr, i, cnt;
>  	struct timespec ts1, ts2;
>  	int ret;
>  
> -	cnt = test->area.max_sz / sz;
> -	dev_addr = test->area.dev_addr;
> +	cnt = t->max_sz / sz;
> +	dev_addr = t->dev_addr;
>  	getnstimeofday(&ts1);
>  	for (i = 0; i < cnt; i++) {
>  		ret = mmc_test_area_io(test, sz, dev_addr, 0, 0, 0);
> @@ -1669,20 +1676,22 @@ static int mmc_test_seq_read_perf(struct mmc_test_card *test, unsigned long sz)
>   */
>  static int mmc_test_profile_seq_read_perf(struct mmc_test_card *test)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned long sz;
>  	int ret;
>  
> -	for (sz = 512; sz < test->area.max_tfr; sz <<= 1) {
> +	for (sz = 512; sz < t->max_tfr; sz <<= 1) {
>  		ret = mmc_test_seq_read_perf(test, sz);
>  		if (ret)
>  			return ret;
>  	}
> -	sz = test->area.max_tfr;
> +	sz = t->max_tfr;
>  	return mmc_test_seq_read_perf(test, sz);
>  }
>  
>  static int mmc_test_seq_write_perf(struct mmc_test_card *test, unsigned long sz)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned int dev_addr, i, cnt;
>  	struct timespec ts1, ts2;
>  	int ret;
> @@ -1690,8 +1699,8 @@ static int mmc_test_seq_write_perf(struct mmc_test_card *test, unsigned long sz)
>  	ret = mmc_test_area_erase(test);
>  	if (ret)
>  		return ret;
> -	cnt = test->area.max_sz / sz;
> -	dev_addr = test->area.dev_addr;
> +	cnt = t->max_sz / sz;
> +	dev_addr = t->dev_addr;
>  	getnstimeofday(&ts1);
>  	for (i = 0; i < cnt; i++) {
>  		ret = mmc_test_area_io(test, sz, dev_addr, 1, 0, 0);
> @@ -1709,15 +1718,16 @@ static int mmc_test_seq_write_perf(struct mmc_test_card *test, unsigned long sz)
>   */
>  static int mmc_test_profile_seq_write_perf(struct mmc_test_card *test)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned long sz;
>  	int ret;
>  
> -	for (sz = 512; sz < test->area.max_tfr; sz <<= 1) {
> +	for (sz = 512; sz < t->max_tfr; sz <<= 1) {
>  		ret = mmc_test_seq_write_perf(test, sz);
>  		if (ret)
>  			return ret;
>  	}
> -	sz = test->area.max_tfr;
> +	sz = t->max_tfr;
>  	return mmc_test_seq_write_perf(test, sz);
>  }
>  
> @@ -1726,6 +1736,7 @@ static int mmc_test_profile_seq_write_perf(struct mmc_test_card *test)
>   */
>  static int mmc_test_profile_seq_trim_perf(struct mmc_test_card *test)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned long sz;
>  	unsigned int dev_addr, i, cnt;
>  	struct timespec ts1, ts2;
> @@ -1737,15 +1748,15 @@ static int mmc_test_profile_seq_trim_perf(struct mmc_test_card *test)
>  	if (!mmc_can_erase(test->card))
>  		return RESULT_UNSUP_HOST;
>  
> -	for (sz = 512; sz <= test->area.max_sz; sz <<= 1) {
> +	for (sz = 512; sz <= t->max_sz; sz <<= 1) {
>  		ret = mmc_test_area_erase(test);
>  		if (ret)
>  			return ret;
>  		ret = mmc_test_area_fill(test);
>  		if (ret)
>  			return ret;
> -		cnt = test->area.max_sz / sz;
> -		dev_addr = test->area.dev_addr;
> +		cnt = t->max_sz / sz;
> +		dev_addr = t->dev_addr;
>  		getnstimeofday(&ts1);
>  		for (i = 0; i < cnt; i++) {
>  			ret = mmc_erase(test->card, dev_addr, sz >> 9,
> @@ -1808,11 +1819,12 @@ static int mmc_test_rnd_perf(struct mmc_test_card *test, int write, int print,
>  
>  static int mmc_test_random_perf(struct mmc_test_card *test, int write)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned int next;
>  	unsigned long sz;
>  	int ret;
>  
> -	for (sz = 512; sz < test->area.max_tfr; sz <<= 1) {
> +	for (sz = 512; sz < t->max_tfr; sz <<= 1) {
>  		/*
>  		 * When writing, try to get more consistent results by running
>  		 * the test twice with exactly the same I/O but outputting the
> @@ -1829,7 +1841,7 @@ static int mmc_test_random_perf(struct mmc_test_card *test, int write)
>  		if (ret)
>  			return ret;
>  	}
> -	sz = test->area.max_tfr;
> +	sz = t->max_tfr;
>  	if (write) {
>  		next = rnd_next;
>  		ret = mmc_test_rnd_perf(test, write, 0, sz);
> @@ -1859,17 +1871,18 @@ static int mmc_test_random_write_perf(struct mmc_test_card *test)
>  static int mmc_test_seq_perf(struct mmc_test_card *test, int write,
>  			     unsigned int tot_sz, int max_scatter)
>  {
> +	struct mmc_test_area *t = &test->area;
>  	unsigned int dev_addr, i, cnt, sz, ssz;
>  	struct timespec ts1, ts2;
>  	int ret;
>  
> -	sz = test->area.max_tfr;
> +	sz = t->max_tfr;
> +
>  	/*
>  	 * In the case of a maximally scattered transfer, the maximum transfer
>  	 * size is further limited by using PAGE_SIZE segments.
>  	 */
>  	if (max_scatter) {
> -		struct mmc_test_area *t = &test->area;
>  		unsigned long max_tfr;
>  
>  		if (t->max_seg_sz >= PAGE_SIZE)

Thanks, pushed to mmc-next for .40.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
