Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1HKIZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:25:46 -0400
Received: from 229.72.64.86.rev.sfr.net ([86.64.72.229]:58583 "EHLO
	hera.goobie.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753850Ab1HKIZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:25:42 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Aug 2011 04:25:42 EDT
Message-ID: <4E439091.6090905@goobie.fr>
Date: Thu, 11 Aug 2011 10:19:29 +0200
From: Simon INIZAN <simon.inizan@goobie.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Barnes, Clifton A." <cabarnes@indesign-llc.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] w1: Add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge
 IC support.
References: <4DE3C363.2030503@goobie.fr> <A8DC7EA93EFCBD4498E3857AFE65E5F13A3DD762@IND07.indesign.net>
In-Reply-To: <A8DC7EA93EFCBD4498E3857AFE65E5F13A3DD762@IND07.indesign.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/2011 14:42, Barnes, Clifton A. wrote:
> On Monday, May 30, 2011, Simon INIZAN wrote:
>
>> However from time to time I a getting stuck in the driver.
> Getting stuck meaning a deadlock?  Is it during a read on a
> sysfs file?  Are you using the driver compiled in or as a
> module?
I have tested the driver with the fix you provided me, I am not getting 
a deadlock anymore.

>> FYI, I am using the GPIO 1-wire driver, and from time to time the gauge is not responding to the w1 queries.
> Is this the same condition you're talking about above?  Does this mean that sometimes
> the sysfs file returns and sometimes it hangs?
>
It seems I am getting some flipped bits on the 1-wire bus (using the 
w1-gpio master),
this is not directly related to your driver but it makes the results not 
very reliable
on my platform (sometimes the rsgain is wrong, so are the currents).
I am getting a 1-wire bus analyzer to investigate the issue.



In the get_current function, you are returning:

sense_res = 1000 / sense_res_raw;
*current_uA = current_raw * (DS2780_CURRENT_UNITS / sense_res);


Which means that we are getting current (in µA) = current_raw (in 
µV/Ohms) * sense_res_raw (in Ohms).
I have replaced it with

sense_res = sense_res_raw;
*current_uA = current_raw * (DS2780_CURRENT_UNITS / sense_res);


Which gives me more consistent results with my measures.

Simon

