Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab2GIFUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 01:20:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36923 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2GIFTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 01:19:42 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-92-4ffa69ec0bba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alex Courbot'" <acourbot@nvidia.com>
Cc: "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>,
        "'Stephen Warren'" <swarren@wwwdotorg.org>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
References: <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com> <20120704130056.GC30009@pengutronix.de>
 <4FF45DDF.9000306@nvidia.com> <20120704152451.GA7333@sirena.org.uk>
 <4FF4FDC0.8020405@nvidia.com> <20120705062011.GI30009@pengutronix.de>
 <4FF53368.6090805@nvidia.com> <20120705064742.GL30009@pengutronix.de>
 <4FF5459F.5090201@nvidia.com>
 <20120705075714.GA26428@avionic-0098.mockup.avionic-design.de>
 <4FF54C6C.1060700@nvidia.com> <4FF5BAEE.3020403@wwwdotorg.org>
In-reply-to: <4FF5BAEE.3020403@wwwdotorg.org>
Subject: RE: [PATCH] pwm-backlight: add regulator and GPIO support
Date: Mon, 09 Jul 2012 14:19:40 +0900
Message-id: <00ae01cd5d92$70d1f9f0$5275edd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1ax+YoDVG9oqo+SdayMDA31hI4PQCyhEoA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd03mb/8DbZ/l7c40feB1eLyrjls
	Fp1fZrE5MHt83iQXwBjFZZOSmpNZllqkb5fAlfHkyE7Wgi1CFROWb2FtYHzL18XIySEhYCLx
	Zd1jFghbTOLCvfVsXYxcHEIC0xklmre+Z4ZwfjFK7J14gQmkik1ATeLLl8PsILaIgIbEt0Vd
	YB3MAguYJCYe2gQ2SkjgM7PExx5rEJtTQFdiw71jYHFhASeJ5U2zgBo4OFgEVCXm7bQCMXkF
	bCX2dqWCVPAKCEr8mHwPrJpZQEti/c7jTBC2vMTmNW+ZQcolBNQlHv3VhbjASOJW10lWiBIR
	iX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwaH9
	THoH46oGi0OMAhyMSjy8K9J/+QuxJpYVV+YeYpTgYFYS4X0EEuJNSaysSi3Kjy8qzUktPsQo
	zcGiJM5r4v3VX0ggPbEkNTs1tSC1CCbLxMEp1cBofXdiSmNHqfD/ex4v297uXNK8gkHTjek8
	+/OJojHHdT3izx/4mBrDuuLL7yMVESXyLWe3LwrrfXdi19USMfnZ3bab1xrIrChfuORDJWPp
	xblJc6RlBTZzHfP59yh90duj4Rf/Xc1oCty0wv1oyVTf8z6r1Hc87n8XPe3XtYLPmi/+Xti2
	pKK0QImlOCPRUIu5qDgRADtuK3dpAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-owner@vger.kernel.org] On Behalf Of Stephen
> Warren
> Sent: Friday, July 06, 2012 1:04 AM
> To: Alex Courbot
> Cc: Thierry Reding; Sascha Hauer; Mark Brown; linux-tegra@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-fbdev@vger.kernel.org
> Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
> 
> On 07/05/2012 02:12 AM, Alex Courbot wrote:
> > On 07/05/2012 04:57 PM, Thierry Reding wrote:
> >> I agree. Non-DT platforms have always used the callbacks to execute this
> >> kind of code. As you've said before there are situations where it isn't
> >> just about setting a GPIO or enabling a regulator but it also requires a
> >> specific timing. Representing this in the platform data would become
> >> tedious.
> >
> > That will settle the whole issue then.
> >
> >> So I think for the DT case you can parse the power-on and power-off
> >> sequences directly and execute code based on it, while in non-DT cases
> >> the init and exit callbacks should be used instead. I think it even
> >> makes sense to reuse the platform data's init and exit functions in the
> >> DT case and implement the parser/interpreter within those.
> >
> > It totally makes sense indeed.
> 
> I don't agree here. It'd be best if non-DT and DT cases worked as
> similarly as possible. Relying on callbacks in one case and
> data-parsed-from-DT in the other isn't consistent with that. After all,
> in the DT case, you parse some data out of the DT and into some data
> structure. In the non-DT case, you can have that data structure passed
> in directly using platform data. Now, there's certainly a need to
> continue to support callbacks for backwards compatibility, at the very
> least temporarily before all clients are converted to the new model, but
> requiring different models rather than simply allowing it seems like a
> bad idea to me.

Hi Alex Courbot,

I couldn't agree with Stephen Warren more.
Could you support DT and non-DT case for backwards compatibility?

Best regards,
Jingoo Han

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

