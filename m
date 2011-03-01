Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1CAI2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:28:22 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:50271 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755269Ab1CAI2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:28:21 -0500
Message-ID: <4D6CADE5.6000206@st.com>
Date: Tue, 1 Mar 2011 13:57:17 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] device.h: add device_set_platdata routine
References: <5c561db378360ad1763da41f8350c7be816daa06.1298953633.git.viresh.kumar@st.com> <20110301075953.GR22310@pengutronix.de>
In-Reply-To: <20110301075953.GR22310@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 01:29 PM, Uwe Kleine-König wrote:
> [added gregkh and lkml to Cc:]
> 

thanks.

> On Tue, Mar 01, 2011 at 10:03:20AM +0530, Viresh Kumar wrote:
>> device.h supports device_get_platdata but doesn't support device_set_platdata.
>> This routine is required by platforms in which device structure is declared
>> in a machine specific file and platform data comes from board specific file.
>>
>> This will be used by SPEAr patches sent in separate patch series.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>> ---
>>  include/linux/device.h |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index 1bf5cf0..6ce0f20 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -576,6 +576,11 @@ static inline void *dev_get_platdata(const struct device *dev)
>>  	return dev->platform_data;
>>  }
>>  
>> +static inline void dev_set_platdata(struct device *dev, void *platdata)
>> +{
>> +	dev->platform_data = platdata;
>> +}
>> +
> Note that dev->platform_data was designed to hold dynamically allocated
> memory, at least it's kfreed in platform_device_release.  And note there
> is platform_device_add_data that kmemdups its argument into
> pdev->dev.platform_data.
> 

Ok. So we should use platform_device_add_data instead and mark our platform
data's struct as __init. So that it doesn't consume any memory after
this routine is done??

> Compared to your dev_set_platdata platform_device_add_data only works
> for platform_devices, don't know if it's worth to change that.
> 

Currently i need this for platform devs only. So its good enough for me.

-- 
viresh
