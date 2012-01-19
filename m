Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2ASHja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:39:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9509 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2ASHj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:39:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jan 2012 23:39:27 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jan 2012 13:09:24 +0530
Subject: RE: [PATCH V1] input: keyboard: Add interrupt keyboard driver.
Thread-Topic: [PATCH V1] input: keyboard: Add interrupt keyboard driver.
Thread-Index: AczWfCHfq+nsxZSGRGaKSLvL5Tnh5AAAKSVA
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC241@BGMAIL01.nvidia.com>
References: <1326778915-2678-1-git-send-email-ldewangan@nvidia.com>
 <20120119072941.GA9668@core.coreip.homeip.net>
In-Reply-To: <20120119072941.GA9668@core.coreip.homeip.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 19, 2012 1:00 PM, Dmitry Torokhov wrote:

> On Tue, Jan 17, 2012 at 11:11:55AM +0530, Laxman Dewangan wrote:
> > This driver enables the key detection of the keys which
> > are connected to interrupt lines.
> > Each key is capable of generating an interrupt, and the
> > statesi (pressed or released) cannot be found by any
> > mechanism.
> > A key press event generated when interrupt occurs, and
> > based on the debounce time setting, a key release event
> > is generated. There is no need to read the state of the
> > keys.
> 
> 
> Is it possible to modify gpio_keys to skip requesting and settin up
> certain gpios and and use it instead of a brand new driver?

I first tried this approach and found that this makes the gpio_keys
driver very complex because almost all places where gpio-apis are
getting called need to put under if condition.
Also there is some special handling for auto key release events
Which makes gpio-key driver again complex.




> 
> --
> Dmitry
