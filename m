Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1FGJ1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:27:53 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:56848 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1FGJ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:27:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DEDF0F8.7030601@cam.ac.uk>
Date: Tue, 07 Jun 2011 10:35:52 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@suse.de>, anish <anish198519851985@gmail.com>,
        devel@driverdev.osuosl.org, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        manuel.stahl@iis.fraunhofer.de
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
References: <1307387257.4327.12.camel@anish-desktop>	 <20110606215549.GA7543@suse.de> <1307398257.4994.30.camel@Joe-Laptop>
In-Reply-To: <1307398257.4994.30.camel@Joe-Laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/11 23:10, Joe Perches wrote:
> On Mon, 2011-06-06 at 14:55 -0700, Greg KH wrote:
>> On Tue, Jun 07, 2011 at 12:37:37AM +0530, anish wrote:
>>> From: anish kumar <anish198519851985@gmail.com>
>>> Replace kmalloc with local variables as it was un-necessary and
>>> also removed the redudant code after this change.
>> SPI data, like USB data, has to come from kmalloced data, not from the
>> stack, or bad things can, and will, happen.
> 
> Perhaps just add a comment like:
> 
> +       u8 *tx = kmalloc(2, GFP_KERNEL);	/* can't be on stack */
> 
> It might be better to do a single kmalloc(4)
> than 2 separate kmalloc(2)'s.
Actually, this little corner of the driver is the only place it isn't
using the buffers allocated with the chip state.  After I send our
latest clean up series in these are all explicitly marked
____cacheline_aligned anyway which should make it clear something
a little unusual is going on.

I'll clean up this function and credit it to Anish (if Anish doesn't
mind of course!)

Jonathan
