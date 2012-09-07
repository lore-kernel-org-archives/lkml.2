Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680Ab2IGN5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:57:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2IGN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:57:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 15/19] mfd: Don't convert just one IRQ using irqdomain if a range is provided
Date: Fri, 7 Sep 2012 13:57:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <201209071337.26587.arnd@arndb.de> <20120907134259.GJ29601@gmail.com>
In-Reply-To: <20120907134259.GJ29601@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071357.27779.arnd@arndb.de>
X-Provags-ID: V02:K0:xrplk+zkBAVCAJ69krkSheI8R63qX7XaEWaOsG6Nwyv
 ISHKVn21pT9jHubNiCZSRzlADlLNJJLxxD54y+6mL2RZs3Ciia
 B4V96v2371CoI7SmHOUEJ41JaxY9FvO8gTAhAqaMTGuCWhFHWf
 PEhkt7KNkwFFBhvGgTuFH4fJc2uw82u9YMuw+4x2oDQF7zi3UQ
 BoJUQ/FzX0QdnAZdJSDPWFcokvONQWQKmWM9/t7bzVTWH8ZO6W
 JW7VOdb60ynXnITTkKc0jBZw+oneBgqVCAUs5IetKRPsG/VMuL
 5/7p/inP9Q2n/dGLxpcUbH8IW5CKF7DrKQfmJQlt6bUeUbEgv3
 LO0MmXX4NFShIWQVy0LI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Lee Jones wrote:
> On Fri, Sep 07, 2012 at 01:37:26PM +0000, Arnd Bergmann wrote:
> > On Friday 07 September 2012, Lee Jones wrote:
> > > On Fri, Sep 07, 2012 at 12:35:41PM +0000, Arnd Bergmann wrote:
> >
> > The examples I had seen before were all just ranges of two interrupts,
> > and in those cases it was clear that splitting them would be best.
> > 
> > In the exampled of the ab8500-gpio driver, it looks like the resource is
> > not actually being used, and the gpio driver implements its own irq_chip,
> > so maybe we can get away with not solving this problem for now.
> 
> Understood. I'd still feel more comfortable if we didn't trash the
> range. I think it would be best to show the warning, and leave the
> range for its target driver to take care - hence the patch.
> 
> ... but it's your call.

I'm fine with whatever Samuel sees fit here.  My personal opinion is
that leaving the range alone for the child driver to do the conversion
would be too inconsistent and only lead to confusion with driver authors.

	Arnd
