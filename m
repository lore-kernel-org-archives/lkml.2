Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2BPK7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:59:09 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:53572 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174Ab2BPK7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:59:05 -0500
Message-ID: <4F3CE15D.6010902@st.com>
Date: Thu, 16 Feb 2012 16:28:37 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "rjw@sisk.pl" <rjw@sisk.pl>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Cc: "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] gpio/gpio-pl061: No need of thaw and poweroff routines
 for hibernate
References: <7662253849428ce018fb7f7359e0585fca9fb597.1326274467.git.viresh.kumar@st.com>
In-Reply-To: <7662253849428ce018fb7f7359e0585fca9fb597.1326274467.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/2012 3:25 PM, Viresh KUMAR wrote:
> pl061 uses same routines for suspend/freeze/poweroff and resume/thaw/restore.
> We are only saving and restoring register values on these routines.
> 
> During hibernation, in freeze() we take a snapshot of gpio registers. In thaw()
> we don't actually need to restore these registers, as power was never shut down
> till now. Similarly, in poweroff() we don't need to take snapshot of these
> registers again, as it was done during freeze() and by now the image is already
> saved on disk.
> 
> This patch passes poweroff() and thaw() routines as NULL to avoid this extra
> work done.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---

Hi Grant/Rafael,

Any feedback on the below patch?

>  drivers/gpio/gpio-pl061.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
> index 84ba1dd..45b884b 100644
> --- a/drivers/gpio/gpio-pl061.c
> +++ b/drivers/gpio/gpio-pl061.c
> @@ -430,7 +430,12 @@ static int pl061_resume(struct device *dev)
>  	return 0;
>  }
>  
> -static SIMPLE_DEV_PM_OPS(pl061_dev_pm_ops, pl061_suspend, pl061_resume);
> +static const struct dev_pm_ops pl061_dev_pm_ops = {
> +	.suspend = pl061_suspend,
> +	.resume = pl061_resume,
> +	.freeze = pl061_suspend,
> +	.restore = pl061_resume,
> +};
>  #endif
>  
>  static struct amba_id pl061_ids[] = {


-- 
viresh
