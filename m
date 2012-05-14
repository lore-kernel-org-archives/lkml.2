Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2ENFkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:40:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12851 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2ENFkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:40:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 13 May 2012 22:40:19 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joe@perches.com" <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 14 May 2012 07:40:14 +0200
Subject: Re: [RFC 1/1] driver core: Add dev_*_ratelimited() family
Thread-Topic: [RFC 1/1] driver core: Add dev_*_ratelimited() family
Thread-Index: Ac0xlApzglbIogy8SuynX+LfEphd8w==
Message-ID: <20120514.084014.1683295633804914511.hdoyu@nvidia.com>
References: <1336836695.17605.12.camel@joe2Laptop><20120514.080008.1401340884821155549.hdoyu@nvidia.com><1336973155.2656.10.camel@joe2Laptop>
In-Reply-To: <1336973155.2656.10.camel@joe2Laptop>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote @ Mon, 14 May 2012 07:25:55 +0200:

> On Mon, 2012-05-14 at 07:00 +0200, Hiroshi Doyu wrote:
> > Hi Joe,
> > 
> > Joe Perches <joe@perches.com> wrote @ Sat, 12 May 2012 17:31:35 +0200:
> > 
> > > On Sat, 2012-05-12 at 12:52 +0200, Hiroshi Doyu wrote:
> > > > Hi,
> > > > 
> > > > An unclosed "if" statement in the MACRO seems a bit risky, but I don't
> > > > have any better/simple solution for this, ATM. Is there any alternative?
> > > 
> > > maybe something like:
> > > 
> > > #define dev_ratelimited_level(dev, level, fmt, ...)
> > > do {
> > > 	static DEFINE_RATELIMIT_STATE(_rs,				\
> > > 				      DEFAULT_RATELIMIT_INTERVAL,	\
> > > 				      DEFAULT_RATELIMIT_BURST);		\
> > > 	if (__ratelimit(&_rs))						\
> > > 		dev_##level(fmt, ##__VA_ARGS__);			\
> > > } while (0)
> > > 
> > > #define dev_emerg_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, emerg, fmt, ##__VA_ARGS__)
> > > #define dev_alert_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, alert, fmt, ##__VA_ARGS__)
> > > #define dev_crit_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, crit, fmt, ##__VA_ARGS__)
> > > #define dev_err_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, err, fmt, ##__VA_ARGS__)
> > > #define dev_warn_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, warn, fmt, ##__VA_ARGS__)
> > > #define dev_notice_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, notice, fmt, ##__VA_ARGS__)
> > > #define dev_info_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, info, fmt, ##__VA_ARGS__)
> > > #define dev_dbg_ratelimited(dev, fmt, ...)				\
> > > 	dev_ratelimited_level(dev, dbg, fmt, ##__VA_ARGS__)
> > 
> > "dev" isn't handled separately with __VA_ARGS__, and failed to build
> > as below:
> > 
> >   Example:
> >     dev_err_ratelimited(&pdev->dev, "%d\n", __LINE__);
> >   
> >   After preprocessded:
> >     do { ... if (___ratelimit(&_rs, __func__)) dev_err("%d\n", 18); } while (0);
> > 
> 
> Sorry, I was just typing in the email client and
> I missed the "dev" argument.
> 
> Add "dev" to the dev_##level statement like:
> 
> #define dev_ratelimited_level(dev, level, fmt, ...)			\
> do {									\
> 	static DEFINE_RATELIMIT_STATE(_rs,				\
> 				      DEFAULT_RATELIMIT_INTERVAL,	\
> 				      DEFAULT_RATELIMIT_BURST);		\
> 	if (__ratelimit(&_rs))						\
> 		dev_##level(dev, fmt, ##__VA_ARGS__);			\
> } while (0)

Verified that the above works. Would you mind sending the complete version of this patch?
