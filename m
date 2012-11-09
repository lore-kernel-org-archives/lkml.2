Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2KISoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:44:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44543 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755329Ab2KISoZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:44:25 -0500
From: Dan Williams <djbw@fb.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Deepak Sikri <deepak.sikri@st.com>,
        "jon.mason@intel.com" <jon.mason@intel.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>
Subject: Re: [PATCH] dmaengine/dmatest: terminate transfers only in case of
 errors
Thread-Topic: [PATCH] dmaengine/dmatest: terminate transfers only in case of
 errors
Thread-Index: AQHNvo6gBAqWD3RE9Um/NJlzPp+4RpfhxoyA
Date: Fri, 9 Nov 2012 18:44:18 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49166B9A82@SC-MBX01-3.TheFacebook.com>
In-Reply-To: <1f83c56ebbe66c00acc7901613da1dc6fdba4a6b.1352474736.git.viresh.kumar@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.18.254]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC1EB3DF4974534BBB60C1058DB66593@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-09_03:2012-11-09,2012-11-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/9/12 7:26 AM, "Viresh Kumar" <viresh.kumar@linaro.org> wrote:

>From: Shiraz Hashim <shiraz.hashim@st.com>
>
>dmatest erroneously terminated transfers in normal cases also leading to
>test failures for multiple threads over a channel. Fix this and
>terminate transfers only in case of errors.
>
>Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
>Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
>---
> drivers/dma/dmatest.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
>index 8f130d4e..ce58b8e 100644
>--- a/drivers/dma/dmatest.c
>+++ b/drivers/dma/dmatest.c
>@@ -509,7 +509,9 @@ err_srcs:
> 			thread_name, total_tests, failed_tests, ret);
> 
> 	/* terminate all transfers on specified channels */
>-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
>+	if (ret)
>+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
>+

This and commit 9704efa "dmaengine/dmatest: Terminate transfers on all
channels in case of error or exit" are broken for channels that don't
implement the optional ->device_control.  Care to fix that up?


--
Dan

