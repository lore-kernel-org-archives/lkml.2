Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2HHJt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:49:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39657 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab2HHJtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:49:55 -0400
Date: Wed, 8 Aug 2012 10:49:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120808094952.GH16861@opensource.wolfsonmicro.com>
References: <20120807170333.GV16861@opensource.wolfsonmicro.com>
 <20120808080411.GB4728@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808080411.GB4728@gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 09:04:12AM +0100, Lee Jones wrote:

> During non-DT boot:
>  - Platform data is passed, which contains an IRQ base
>  - If an IRQ base is requested we use it to register a Legacy IRQ Domain
>  - MFD adds the IRQ base to the hwirq and registers it as a virq

Just don't do this step - the only reason to do it is for mapping back
into a linear domain but if you're going to do this...

>  - AB8500 child devices use *_get_virq() to convert virq to virq - *ERROR*

...then it's redundant.  The mapping functions in the domain code
replace this functionality.
