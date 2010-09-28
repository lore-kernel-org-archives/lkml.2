Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0I1VZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:25:52 -0400
Received: from tuxonice.net ([74.207.252.127]:40434 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0I1VZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:25:49 -0400
X-Bogosity: Ham, spamicity=0.000007
Message-ID: <4CA25D59.2040409@tuxonice.net>
Date: Wed, 29 Sep 2010 07:25:45 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: tuxonice-devel@tuxonice.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Nigel's current for-rafael queue
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> (sfid-20100925_095651_884433_67642C74) <201009282145.46948.Martin@lichtvoll.de>
In-Reply-To: <201009282145.46948.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin.

On 29/09/10 05:45, Martin Steigerwald wrote:
> Am Samstag 25 September 2010 schrieb Nigel Cunningham:
>> Hi Rafael.
>
> Hi Nigel,
>
>> Please find attached a slightly updated version of the patchset I sent
>> a few months ago. The main change is that I've prepended and additional
>> patch which lets the user see the speed at which the image is being
>> read and written. This is accomplished by recording the MB/s in a
>> single byte in the image header, and using a couple of __nosavedata
>> variables to get the data back through the atomic restore. I realise
>> the char limits us to 255MB/s at the moment. In future patches, I
>> intend to address this by storing the data in a 'proper' image header
>> (it's a real problem - TuxOnIce reads and writes on the same set up at
>> speeds around 250MB/s).
>>
>> Results on my Dell XPS M1530, which has an SSD hard drive are:
>
> I found one issue with this patchset or more precise I think with the
> state of in-kernel-suspend before:
>
> I accidentally booted a kernel without your patches and it didn't seem to
> stop on the hibernation image from the kernel with your patches. Well I
> let my laptop unattended for a little while, so when there has been a
> (short) timeout, I might have missed that message.
>
> I lost a hibernation image this way which caused successful journal replay
> on my Ext4 filesystems.
>
> Does a kernel without your patches offer to reboot into the correct kernel,
> then it finds a hibernation image from a kernel with your patches?
>
> If not, I think for the future it should give a warning with a quite high
> timeout, and offer to reboot into the right kernel.

My patches only focus on the I/O code in swsusp at the moment. I know 
there are still tons of things from TuxOnIce that could be put into 
swsusp, but at the moment I'm just focusing on I/O code.

The answer at the moment is therefore "I'm sorry, but if you're going to 
try out this code, you're going to have to live without some of 
TuxOnIce's nice features until I can split them into nice little 
patches, and start trying to persuade Rafael they're a good idea to merge."

Sorry!

Nigel
