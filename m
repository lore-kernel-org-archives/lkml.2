Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1KHNcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:32:13 -0500
Received: from smtp-out-101.synserver.de ([212.40.185.101]:1146 "HELO
	smtp-out-097.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754242Ab1KHNcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:32:11 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17822
Message-ID: <4EB92F78.8090200@metafoo.de>
Date: Tue, 08 Nov 2011 14:32:40 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111005 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: jic23@cam.ac.uk
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        guenter.roeck@ericsson.com, khali@linux-fr.org,
        dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 0/6 V2] IIO: Out of staging step 1: The core
References: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 03:52 PM, jic23@cam.ac.uk wrote:
> From: Jonathan Cameron <jic23@kernel.org>
> 
> [...]
> Dear All,
> 
> Firstly note that I have pushed ahead of this alongside the ongoing
> discussions on how to handle in kernel interfaces for the devices
> covered by IIO.  I propose to build those on top of this patch
> set and will be working on that support whilst this set is
> under review.
> 
> Secondly, this code has some namespace clashes with the staging
> IIO code, so you will need a couple of patches that can be found
> in https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
> 
> This is our first attempt to propose moving 'some' of the
> Industrial I/O subsystem out of staging.  This cover letter
> attempts to explain what IIO is and why it is needed.
> All comments welcome on this as well as the code!


I don't think moving just part of the IIO core out of staging will work. We
now end up with two competing frameworks for the same purpose which mostly
have the same API. If I for example enable both ST_IIO and IIO at the same
time everything will explode, since both want to register the same device class.

In my opinion we should move all of the core interface including events and
buffer support at once. Drivers of course can stay in staging. I guess the
main reason why this code is still in staging is that we don't fell
confident enough about the user-space ABI yet. The overall code quality is
ok and there are no major problems with the internal API.

With the new in-kernel interface the user-space buffer support becomes just
another consumer anyway. So we could keep it in staging for now. Something
similar is probably possible for event support. Provide the in-kernel
interfaces out of staging, but keep the user-space delivery mechanism in
staging for now.

I'll try to come up with some patches which allow coexistence of the
in-staging and out-of-staging IIO parts.

- Lars
