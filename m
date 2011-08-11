Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1HKUvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:51:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48902 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1HKUvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:51:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ZHAM3pfHZid8DVcUULUKXGkviKzH0uG3fRlwsMpvu8hSEX6crbQZUiNOJx7bbxTKI
	ZAaYTr9NyhpeksA1nqPIg==
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
	<CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
	<20110806084805.GA18098@sirena.org.uk>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
Date: Thu, 11 Aug 2011 13:51:08 -0700
Message-ID: <CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
From: Colin Cross <ccross@google.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Dooks <ben-linux@fluff.org>, Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:35 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Mark Brown wrote at Saturday, August 06, 2011 2:48 AM:
>> On Fri, Aug 05, 2011 at 09:33:31PM -0700, Colin Cross wrote:
> ...
>> > NAK - moving the suspend order around is not the correct way to solve
>> > this.  If wm8903 needs to talk to the i2c bus in its suspend handler,
>> > it needs to be child device on the i2c bus.  suspend_noirq is for
>>
>> WM8903 is an I2C device.  The problem is that it's suspended as part of
>> the ASoC suspend since the audio subsystem is composed of multiple
>> devices that all need to work together coherently.  I did start doing
>> some stuff to bodge around this like we do on probe but there are enough
>> system wide problems with this that it didn't seem worth the complexity
>> when the existing workarounds are so straightforward.
>
> Colin, given Mark's explanation, are you OK with the patch now?

It's still not the right way to handle this, are you going to mark
every I2C controller as suspend_noirq?  What happens when you find an
I2C controller that needs its irq on to suspend?  These are the kinds
of hacks we've been asked not to do in ARM, so I'd like to see a
response from the I2C maintainers.
