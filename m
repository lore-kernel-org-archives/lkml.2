Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2CZL6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:58:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34761 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab2CZL57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120326030239.GA4623@envy17>
References: <1330491360-1283-1-git-send-email-myungjoo.ham@samsung.com>
	<1331096778-26186-1-git-send-email-myungjoo.ham@samsung.com>
	<20120324163542.GA23888@envy17>
	<CAJ0PZbSn_gf5yhO4bbmZ8duv19E8zLrKigx0ttb38TY_BOnLyg@mail.gmail.com>
	<20120326030239.GA4623@envy17>
Date: Mon, 26 Mar 2012 20:57:59 +0900
Message-ID: <CAJ0PZbThSc=WkmeOYtykTKZ7bhBHJa7KYYPeWPLNy_suCD0f+A@mail.gmail.com>
Subject: Re: [PATCH v3] PM / QoS: add pm_qos_update_request_timeout API
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: markgross@thegnar.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:02 PM, mark gross <markgross@thegnar.org> wrote:
> On Mon, Mar 26, 2012 at 10:41:15AM +0900, MyungJoo Ham wrote:
>> On Sun, Mar 25, 2012 at 1:35 AM, mark gross <markgross@thegnar.org> wrote:
>> > I apologize for the lat replay and admit that I was probably wrong to
>> > oppose the idea of time out pm_qos requests.  (last week we bumped into
>> > a need for them and now I get it.)
>> >
>> >
>> > On Wed, Mar 07, 2012 at 02:06:18PM +0900, MyungJoo Ham wrote:
>> >> The new API, pm_qos_update_request_timeout() is to provide a timeout
>> >> with pm_qos_update_request.
>> >>
>> >> For example, pm_qos_update_request_timeout(req, 100, 1000), means that
>> >> QoS request on req with value 100 will be active for 1000 jiffies.
>> >> After 1000 jiffies, the QoS request thru req is rolled back to the
>> >> request status when pm_qos_update_request_timeout() was called. If there
>> >> were another pm_qos_update_request(req, x) during the 1000 jiffies, this
>> >> new request with value x will override as this is another request on the
>> >> same req handle. A new request on the same req handle will always
>> >> override the previous request whether it is the conventional request or
>> >> it is the new timeout request.
>> >>
>> >> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> []
>> >> @@ -77,6 +79,8 @@ void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
>> >>                       s32 value);
>> >>  void pm_qos_update_request(struct pm_qos_request *req,
>> >>                          s32 new_value);
>> >> +void pm_qos_update_request_timeout(struct pm_qos_request *req,
>> >> +                                s32 new_value, unsigned long timeout_ms);
>> > is ms the right units?  could we ever need us?
>> >
>>
>> Because jiffies are used for scheduling tasks, I thought ms should be
>> fine and having some devices running fast for some msecs longer won't
>> hurt. However, do you expect scheduling tasks or jiffies may use usecs
>> later? I don't mind using usecs instead of msecs here; thus, I'll
>> update this to use usecs. I'll resend patchset soon.
>>
>
> I am just asking a question.  I'm not sure if us or ms are the better
> units off the top of my head.
>
> --mark
>


For the current structure of Linux (scheduling task, jiffies), I
thought that none of the two is better than the another because the
duration should not be so long and the jiffies are larger than 1 ms.

However, it turns out to be not true: some uses jiffies < 1ms (alpha),
some uses jiffies not cleanly dividable with msecs (omap). Thus, it
appears that usecs is better. Thus, the parameter should be usecs
rather than msecs.



Cheers!
MyungJoo.



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
