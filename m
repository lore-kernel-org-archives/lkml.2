Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2DODPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 23:15:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2DODPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 23:15:45 -0400
Message-ID: <4F8A3D5C.8030001@gmail.com>
Date: Sat, 14 Apr 2012 22:15:40 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dong Aisheng <dongas86@gmail.com>
CC: Dong Aisheng <dong.aisheng@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/1] dt: add of_get_child_count helper function
References: <1328980929-5423-1-git-send-email-dong.aisheng@linaro.org> <4F381F6C.1030908@gmail.com> <CAA+hA=RpfLfUyupVqBpMHsRN1h5KG5eLD86DkDygZRk5nCUtqA@mail.gmail.com>
In-Reply-To: <CAA+hA=RpfLfUyupVqBpMHsRN1h5KG5eLD86DkDygZRk5nCUtqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 01:07 PM, Dong Aisheng wrote:
> Hi Rob,
> 
> On Mon, Feb 13, 2012 at 4:22 AM, Rob Herring <robherring2@gmail.com> wrote:
>> On 02/11/2012 11:22 AM, Dong Aisheng wrote:
>>> Currently most code to get child count in kernel are almost same,
>>> add a helper to implement this function for dt to use.
>>>
>>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>>
>>> ---
>>> Hi Rob,
>>>
>>> Since my imx pinctrl driver series still depends on the pinctrl core dt
>>> binding patch which is still not in mainline, i'd like this pure dt patch
>>> go separately first in case others want to use.
>>>
>>
>> Applied for 3.4.
>>
> I did not see this in 3.4 kernel.
> Anything i missed?
> My pinctrl-imx driver i just sent is using this.

Sorry, I did not get this sent to Grant in time. Go ahead and merge it
with your pinctrl driver.

Rob

> 
> Regards
> Dong Aisheng
> 
>> Rob
>>
>>> changes v2->v3:
>>>  Addressed some people's comments:
>>>  * do not use assignment as expression
>>>  * return 0 for non-dt case
>>>
>>> Changes v1->v2:
>>>  * change the name from of_get_child_number to of_get_child_count
>>> ---
>>>  include/linux/of.h |   16 ++++++++++++++++
>>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/include/linux/of.h b/include/linux/of.h
>>> index a75a831..ae242ef 100644
>>> --- a/include/linux/of.h
>>> +++ b/include/linux/of.h
>>> @@ -195,6 +195,17 @@ extern struct device_node *of_get_next_child(const struct device_node *node,
>>>       for (child = of_get_next_child(parent, NULL); child != NULL; \
>>>            child = of_get_next_child(parent, child))
>>>
>>> +static inline int of_get_child_count(const struct device_node *np)
>>> +{
>>> +     struct device_node *child = NULL;
>>> +     int num = 0;
>>> +
>>> +     while ((child = of_get_next_child(np, child)) != NULL)
>>> +             num++;
>>> +
>>> +     return num;
>>> +}
>>> +
>>>  extern struct device_node *of_find_node_with_property(
>>>       struct device_node *from, const char *prop_name);
>>>  #define for_each_node_with_property(dn, prop_name) \
>>> @@ -268,6 +279,11 @@ static inline bool of_have_populated_dt(void)
>>>  #define for_each_child_of_node(parent, child) \
>>>       while (0)
>>>
>>> +static inline int of_get_child_count(const struct device_node *np)
>>> +{
>>> +     return 0;
>>> +}
>>> +
>>>  static inline int of_device_is_compatible(const struct device_node *device,
>>>                                         const char *name)
>>>  {
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

