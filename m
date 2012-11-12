Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2KLL7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:59:38 -0500
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:50272 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2KLL7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:59:33 -0500
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [PATCH v3] staging: ste_rmi4: Convert to Type-B support
Thread-Topic: [PATCH v3] staging: ste_rmi4: Convert to Type-B support
Thread-Index: AQHNutYcuwEJvMgSyU2cH1aXlQU3sZfmIc8A
Date: Mon, 12 Nov 2012 11:59:26 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F62275@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121104215335.GA1060@polaris.bitmath.org>
In-Reply-To: <20121104215335.GA1060@polaris.bitmath.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-HK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.51.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

Really thanks a lot for all your advice.

> > @@ -751,7 +739,7 @@ static int synaptics_rmi4_i2c_query_device(struct
> synaptics_rmi4_data *pdata)
> >  				pdata->fn01_data_base_addr =
> >  						rmi_fd.data_base_addr;
> >  				break;
> > -			case SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM:
> > +			case SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM:
> >  				if (rmi_fd.intr_src_count) {
> >  					rfi = kmalloc(sizeof(*rfi),
> >  								GFP_KERNEL);
> > @@ -761,7 +749,8 @@ static int synaptics_rmi4_i2c_query_device(struct
> synaptics_rmi4_data *pdata)
> >  								__func__);
> >  							return -ENOMEM;
> >  					}
> > -					retval = synpatics_rmi4_touchpad_detect
> > +					retval =
> > +					synpatics_rmi4_touchscreen_detect
> >  								(pdata,	rfi,
> >  								&rmi_fd,
> >  								intr_count);
> 
> Odd line break is a clear sign that something could be broken out into its own
> function.
> 
> > @@ -854,8 +843,9 @@ static int synaptics_rmi4_i2c_query_device(struct
> synaptics_rmi4_data *pdata)
> >  		list_for_each_entry(rfi, &rmi->support_fn_list, link) {
> >  			if (rfi->num_of_data_sources) {
> >  				if (rfi->fn_number ==
> > -					SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM) {
> > -					retval = synaptics_rmi4_touchpad_config
> > +					SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM) {
> > +					retval =
> > +					synaptics_rmi4_touchscreen_config
> >  								(pdata, rfi);
> >  					if (retval < 0)
> >  						return retval;
> 
> Same here.
> 

As you mentioned, there are odd lines in patch v3.
These odd lines are because that lines are over 80 characters after "touchpad" is
replaced by "touchscreen".

In patch v4, I did the splitting of the functions to fix line over 80 characters issue
(and other irrelevant work).

Somehow I realized that code itself can be optimized, and there is no need
to break out function to fix line over 80 characters issues. Therefore I rollback
patch to v3, and reorganized code flow to fix line over 80 characters issues in
patch v5. Patch v5 only includes odd lines issue fixed, although it looks a little
too large.

And these changes have been verified with Pandaboard.

Greatly appreciate your suggestions, and please let me know if you have any
concerns about v5 (https://lkml.org/lkml/2012/11/8/31).

Yours very truly,
Alexandra
