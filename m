Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2G3JLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:11:07 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:41481
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab2G3JLE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:11:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432I1447Izz1202hzz8275bh8275dh84d07hz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Aggrwal Poonam-B10812 <B10812@freescale.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Singh Sandeep-B37400 <B37400@freescale.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [2/3][PATCH][v2] TDM Framework
Thread-Topic: [2/3][PATCH][v2] TDM Framework
Thread-Index: AQHNbAEGk9oFge1sME+iu8BW01Zyh5c9vv6AgAPFeDA=
Date: Mon, 30 Jul 2012 09:10:48 +0000
Message-ID: <ACB6D0C0104CFF42A45A5D82A0DD4F3D079C0B75@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727175939.GA23105@kroah.com>
In-Reply-To: <20120727175939.GA23105@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.133.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+poonam.aggrwal=freescale.com@lists.ozlabs.org] On Behalf Of Greg
> KH
> Sent: Friday, July 27, 2012 11:30 PM
> To: Singh Sandeep-B37400
> Cc: devel@driverdev.osuosl.org; linuxppc-dev@lists.ozlabs.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [2/3][PATCH][v2] TDM Framework
> 
> On Fri, Jul 27, 2012 at 07:35:38PM +0530, sandeep@freescale.com wrote:
> > +/* Data structures required for sysfs */ static struct tdm_sysfs attr
> > += {
> > +	.attr.name = "use_latest_data",
> > +	.attr.mode = 0664,
> > +	.cmd_type = TDM_LATEST_DATA,
> > +};
> 
> What is this for?
This knob is to control the behavior of the TDM framework with respect to handling the received TDM frames.
The framework layer receives the TDM frames from the TDM adapter driver, de-interleaves the data and sends to respective client modules.
In the case when the TDM client module has not consumed the data and emptied the Buffer, this flag decides whether to discard the un-fetched data, or discard the latest received data.

> 
> > +int tdm_sysfs_init(void)
> > +{
> > +	struct kobject *tdm_kobj;
> > +	int err = 1;
> > +	tdm_kobj = kzalloc(sizeof(*tdm_kobj), GFP_KERNEL);
> > +	if (tdm_kobj) {
> > +		kobject_init(tdm_kobj, &tdm_type);
> > +		if (kobject_add(tdm_kobj, NULL, "%s", "tdm")) {
> > +			pr_err("tdm: Sysfs creation failed\n");
> > +			kobject_put(tdm_kobj);
> > +			err = -EINVAL;
> > +			goto out;
> > +		}
> > +	} else {
> > +		pr_err("tdm: Unable to allocate tdm_kobj\n");
> > +		err = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +out:
> > +	return err;
> > +}
> 
> You just leaked memory, what are you trying to do here?
> 
> And why are you using "raw" kobjects?  That's a sure sign that something
> is really wrong.
Will refer the documentation. Not very experienced on this stuff. Thanks for the comment.
> 
> Your code doesn't look like it is tied into the driver model at all, why
> not?  What are you trying to do here?
This is a framework layer, not associated to a particular device. TDM adapter drivers will register to this framework.
We got this comment in internal freescale review list also.
> 
> Also, when creating new sysfs entries, like you are attempting to do here
> (unsuccessfully I might add), you must create Documentation/ABI/ files as
> well.
Ok.
> 
> And, to top it all off, you do realize you are asking us to do code
> review in the middle of the merge window, when we are all busy doing
> other things?
Apologize for asking a review in the merge window time frame.
Are there any guidelines when to send something for a review? We will be careful next time.

Regards
Poonam
> 
> greg k-h
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


