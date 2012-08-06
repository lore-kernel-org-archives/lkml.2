Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2HFCSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:18:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43438 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab2HFCSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:18:21 -0400
Message-ID: <501F296B.4070004@wwwdotorg.org>
Date: Sun, 05 Aug 2012 20:18:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Johannes Stezenbach <js@sig21.net>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: DT GPIO numbering?
References: <20120801152240.GA16388@sig21.net> <CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com>
In-Reply-To: <CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 04:06 AM, Linus Walleij wrote:
> On Wed, Aug 1, 2012 at 5:22 PM, Johannes Stezenbach <js@sig21.net> wrote:
> 
>> I'm currently learning how Linux devicetree support works,
>> here is one question I couldn't find an answer for.
>>
>> I understand that within the devicetree GPIOs are referenced by phandle,
>> thus the numbers are irrelevant.  However, in sysfs the number is
>> what is used to access the GPIO, e.g. for debugging or
>> blinkenlight apps.  How does this fit together?
> 
> I think it simply does not fit together.
> 
> Grant & me has been claiming the GPIO sysfs interface is a bit
> crazy from time to time.
> 
> My long-term plan would be to replace it with /dev/gpio/gpioN
> device nodes per-gpiochip and use ioctl etc to control these
> beasts instead. However one does not do that overnight,
> and my life is too busy, and other refactorings also need to
> happen :-/

I can't comment on the sysfs-vs-dev interface location, but I don't
think it addresses Johannes' issue; finding out which GPIO IDs are
provided by which devices.

Perhaps in each device's sysfs node, there should be some information
re: which GPIO range it provides. Right now, perhaps a text file with
the GPIO base it it. With the new /dev interface you mention above,
perhaps a symlink to the /dev file, or a file containing the /dev file's
major/minor number. Or, is there such a thing already (other than
debugfs's gpio file).
