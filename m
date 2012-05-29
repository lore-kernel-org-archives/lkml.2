Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab2E2Gni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:43:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49245 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2E2Gnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:43:37 -0400
Message-ID: <4FC47003.1080906@zytor.com>
Date: Mon, 28 May 2012 23:43:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
References: <4FC40C74.8050003@zytor.com>  <20120527205020.GA3050@mail.gnudd.com> <20120529063738.GA22711@mail.gnudd.com>
In-Reply-To: <20120529063738.GA22711@mail.gnudd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 11:37 PM, Alessandro Rubini wrote:
>> There is absolutely NO WAY this kind of ARM-like sh*t is going into the
>> x86 kernel.
> 
> Ok. Then, how do you suggest to provide platform data to the various
> drivers?  It really depends on how the board is wired.
> 
> BTW: it's not uncommon for pci cards to differ in the same way, see
> drivers/media/video/bt8xx/bttv-cards.c for example.  I can have all
> board configurations without config choices or whatever is acceptable.
> Just tell me how to proceed.
> 

We have two mechanisms for parameterizing this kind of information: ACPI
5 (which can be considered the "native" method on x86) or flattened
device tree (as already used by the CE4100 platform.)  Keep in mind that
an explicit goal for Linux/x86 is that the same kernel should boot on
all platforms, and backsliding on that is not acceptable.

The best is for the firmware on your platforms to provide the ACPI or
DTB information, as it should.  If it doesn't, it gets nastier, but
there is absolutely no way we are going into the ARM swamp of having
different kernels for different boards.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

