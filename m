Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab2HVHeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:34:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:44022 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab2HVHer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:34:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="212116973"
Date: Wed, 22 Aug 2012 15:29:18 +0800
From: Feng Tang <feng.tang@intel.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Message-ID: <20120822152918.3e59616e@feng-i7>
In-Reply-To: <4401854.hVfHzgeqjT@ws-stein>
References: <4401854.hVfHzgeqjT@ws-stein>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012 08:30:35 +0200
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> Hello,
> 
> I just noticed the 3.4 linux kernel fails to sucessfully probe the i2c-eg20t 
> driver. I returns with EBUSY error. It worked on the 3.0 kernel. To my view it 
> is caused the commit 07e8a51ff68353e01d795cceafbac9f54c49132b ( i2c-eg20t: use 
> i2c_add_numbered_adapter to get a fixed bus number).
> The reason it actually fails is that the i2c-isch driver is registered 
> beforehand which gets bus number 0. But this one is the bus number the eg20t 
> driver wants to register.

Make sense.

> A possibility is that if i2c_add_numbered_adapter failed with EBUSY just use 
> i2c_add_adapter to get at least the driver working, but with a non-fixed bus 
> number. Opinions?

Or can we give it a fixed offset, like let the i2c_eg20t controller bus number
start with 4? I don't expect there will be more than 4 other i2c controllers 
on EG20T compatible platforms.

Thanks,
Feng
