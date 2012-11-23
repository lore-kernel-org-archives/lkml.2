Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2KWMjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:39:25 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63626 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2KWMjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:39:24 -0500
MIME-Version: 1.0
In-Reply-To: <20121123093633.GD17471@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
	<b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
	<20121122112451.GE4328@gmail.com>
	<CAKohpo=EWFNddjMNwHO4u4-bi1AQ4cvsJ4DfFOgaFv3oVfheZg@mail.gmail.com>
	<20121123093633.GD17471@gmail.com>
Date: Fri, 23 Nov 2012 18:09:23 +0530
Message-ID: <CAKohpo=4orAgwVRRvukj+tu67CyVvoUegsJ7eXaCMA9exruqEA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 15:06, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 23 Nov 2012, Viresh Kumar wrote:
>>       pdev = platform_device_alloc(cell->name, id + cell->id);
>>
>> This is required when we have multiple instances of MFD device present
>> on board. How do you want me to handle this ?
>
> There are lots of examples of this already. I have to leave something
> to the imagination, or I'll be requesting a cut of your salary. :D

My manager already reduced my salary by 20% after reading this mail :(

Ok, this is what my understanding of whole this is. Platform devices are
named like:
- pdev-name: if id passed in pdev.id is -1
- pdev-name.0[1|2|...]: if id passed is 0[1|2|...]
- pdev-name.<dynamically allocated by kernel>: if id passed is -2

Now, we don't declare cell->id fields and they are currently zero and so
value is passed from pdata->id field. So, for example with multiple instances
of stmpe on a board, we have:

- stmpe-0: //Name just for reference...
   - stmpe-gpio.0
   - stmpe-ts.0
- stmpe-1:
   - stmpe-gpio.1
   - stmpe-ts.1
- stmpe-2:
   - stmpe-gpio.2
   - stmpe-ts.2

I main idea is to distinguish various instances of sub modules, like stmpe-gpio.
And this works well with non-DT support we have currently.

With DT, i am not sure how should we pass id field to mfd_add_devices(). If
we pass it -1, then multiple instances will have same name: "stmpe-gpio"

Sorry, for my lack of knowledge. Don't send another mail with salary cut
suggestion as that will make it -40% in total ;)

Thanks for reviewing :)

--
viresh
