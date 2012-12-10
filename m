Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2LJWJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:09:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51434 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2LJWJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:09:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/3] dmaengine: dw_dmac: Enhance device tree support
Date: Mon, 10 Dec 2012 22:08:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Viresh Kumar <viresh.kumar@linaro.org>, vinod.koul@intel.com,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com
References: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org> <169edae67b9a051ca7448e5b62c3cd2c5c1db470.1350360935.git.viresh.kumar@linaro.org>
In-Reply-To: <169edae67b9a051ca7448e5b62c3cd2c5c1db470.1350360935.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212102208.52347.arnd@arndb.de>
X-Provags-ID: V02:K0:6PK0nzM3Y+fNCeSlmXQj2oF+8lSN9EWUiJTem/FiWCt
 S9+myFpWEob3YQqeOW7+EvWTusQ2/a8mf8hPJkTvfL/UYZE5FO
 fBHkkS8FyCeJSOPvepwKi6kjSAyXufSeYoMGYPB2KxGlLAekDG
 l7YzwiXXqWG7jMMViAbJAT9zu+yoDWBUgdYbKFw63h2gOq54uZ
 /F6Bu8MT+HRnO3/z2s2b+JOXIjQbN414Aebe5OVMNbduK1L3a4
 A1brCkhm+44owqDFfmdhBxP3CR2FKlLLPHVeZsokKwu4YA6DJN
 udUsuhKJgD0bsRFnf/g+4B3pCJ9ioLTi4YhwMvjSsSIlFwkWRG
 G1f6fBQmW1ScOtAdcP8E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012, Viresh Kumar wrote:
> dw_dmac driver already supports device tree but it used to have its platform
> data passed the non-DT way.
> 
> This patch does following changes:
> - pass platform data via DT, non-DT way still takes precedence if both are used.
> - create generic filter routine
> - Earlier slave information was made available by slave specific filter routines
>   in chan->private field. Now, this information would be passed from within dmac
>   DT node. Slave drivers would now be required to pass bus_id (a string) as
>   parameter to this generic filter(), which would be compared against the slave
>   data passed from DT, by the generic filter routine.
> - Update binding document
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

I'm deeply sorry for the very late complaint on this, but I only now
noticed this patch as I was seeing build breakage in linux-next
because of it.

The build bug is not the problem however, but the abuse of the
API is. Andy, are you sure you understood what this does when
you gave you Reviewed-by comment?

Viresh, there are multiple problems with your approach unfortunately:

* It does not follow the binding from
  Documentation/devicetree/bindings/dma/dma.txt

* It requires slave drivers to know that they are using the dw_dmac
  driver and pass a pointer to dw_generic_filter, which is not
  generic at all

* It requires the dmac node to have information about all slaves

There are also some minor issues, such as the naming of DT
properties, but the above need to be resolved first.

	Arnd
