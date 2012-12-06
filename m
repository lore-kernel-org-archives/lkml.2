Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2LFB6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:58:24 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62117 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab2LFB6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:58:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121205224203.691153E0E22@localhost>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
	<121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
	<20121130105731.GN3176@sortiz-mobl>
	<20121130154542.GG23648@gmail.com>
	<CAKohpokLVEH+4F_VXh5auUm48cWWe0mumZME8yOCcAezcwJbCQ@mail.gmail.com>
	<20121205224203.691153E0E22@localhost>
Date: Thu, 6 Dec 2012 07:28:22 +0530
Message-ID: <CAKohponjLp214EPKgNHqP2N8Tje9U8ZxgywUTSvsjE-TqHy+xw@mail.gmail.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks for explaining :)

On 6 December 2012 04:12, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sat, 1 Dec 2012 00:33:46 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> This first tries to match the table my patch added, _BUT_ the string will
>> never match as we had "st,stmpe810" in table and "stmpe810" in dev.
>
> of_driver_match_device() matches against the compatible list in
> dev->of_node, not against the device name. So, if the compatible
> property has a string that is in the table, then it really should match
> against it.

How could i misread it? Yes you are correct.

>> static int i2c_device_probe(struct device *dev)
>> {
>>         .....
>>       status = driver->probe(client, i2c_match_id(driver->id_table, client));
>
> Here things are a bit wonky. Even if matched against the table, it is

table means of_device_id table ?

> possible that it also matches against i2c_match_id() and that data is
> passed to the driver.

It is a possibility or guarantee ? And so whatever device name we got from
modalias routine, should match with the names in driver->id_table.

> But regardless, it is the responsiblity of the probe function to go and
> look if of_driver_match_device() matches against anything if it cares
> about the of_match_table entries (for instance, if there is extra data
> attached).

Ok, so filling .data field in of_device_id[] is not required for our case as
we aren't doing anything special in our drivers.

>> Which will again match the legacy table to find correct struct i2c_device_id *id
>> to pass to probe().
>>
>> So, the final question: WTF is of_match_table for?
>
> A bit of history is valuable here. The whole of_modalias_node() thing is
> really just a best-effort heuristic for figuring out which driver
> *might* work against a device described in the device tree. It won't
> work in all circumstances (and it was created at a time when there was
> resistance to adding DT knowledge to drivers). An of_match_table is the
> robust way of identifying specific devices and allows for matching
> against any entry in the compatible list.

Got it.
