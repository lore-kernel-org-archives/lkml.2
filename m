Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1LHDSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:18:44 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:34954 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab1LHDSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:18:43 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] [media] V4L: atmel-isi: add code toenable/disableISI_MCK clock
Date: Thu, 8 Dec 2011 11:18:23 +0800
Message-ID: <4C79549CB6F772498162A641D92D5328039E9F92@penmb01.corp.atmel.com>
In-Reply-To: <20111207223952.GH14542@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] [media] V4L: atmel-isi: add code toenable/disableISI_MCK clock
Thread-Index: Acy1MSuxCHcxn45MSzCSfS1kYZVU6wAJizzA
References: <1322647604-30662-1-git-send-email-josh.wu@atmel.com> <20111207084958.GA14542@n2100.arm.linux.org.uk> <4C79549CB6F772498162A641D92D5328039E9C15@penmb01.corp.atmel.com> <20111207223952.GH14542@n2100.arm.linux.org.uk>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 08 Dec 2011 03:18:25.0951 (UTC) FILETIME=[0C9172F0:01CCB558]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 08, 2011 6:40AM, Russell King wrote:

> On Wed, Dec 07, 2011 at 06:12:52PM +0800, Wu, Josh wrote:
>> Hi, Russell King
>> 
>> On Wed, Dec 07, 2011 at 4:50 PM, Russell King wrote:
>> 
>> > On Wed, Nov 30, 2011 at 06:06:43PM +0800, Josh Wu wrote:
>> >> +	/* Get ISI_MCK, provided by programmable clock or external clock
>> */
>> >> +	isi->mck = clk_get(dev, "isi_mck");
>> >> +	if (IS_ERR_OR_NULL(isi->mck)) {
>> 
>> > This should be IS_ERR()
>> 
>> So it means the clk_get() will never return NULL even when clk
structure
>> is NULL in clk lookup entry. Right?

> It is not the drivers business to know whether NULL is valid or not.

> clk_get() is defined to either return an error pointer, or a cookie
> which the rest of the clk API must accept.

> If an implementation decides that clk_get() can return NULL and deals
> with that in the rest of the API (eg, to mean 'there is no clock but
> don't fail for this') then drivers must not reject that.

> If a driver rejects NULL then it is performing checks outside of the
> definition of the clk API, and making assumptions about the nature of
> valid cookies.

Thanks for the feedback. I will send v3 patch which will not check the
null return value.

Best Regards,
Josh Wu
