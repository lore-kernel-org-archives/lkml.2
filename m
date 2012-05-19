Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2ESGlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:41:11 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:56510 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab2ESGlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:41:09 -0400
Message-ID: <4FB740C4.6080805@mev.co.uk>
Date: Sat, 19 May 2012 07:42:12 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: [PATCH] staging: comedi: cleanup all the comedi_driver 'detach'
 functions
References: <201205171711.14968.hartleys@visionengravers.com> <20120519003204.GA1210@kroah.com>
In-Reply-To: <20120519003204.GA1210@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/12 01:32, Greg KH wrote:
> On Thu, May 17, 2012 at 05:11:14PM -0700, H Hartley Sweeten wrote:
>> All of the printk output is really just noise. The user did a rmmod to
>> unload the driver, we really don't need to tell them about it.
>>
>> Also, some of the messages are output using:
>>
>> 	dev_dbg(dev->hw_dev, ...
>> or
>> 	dev_info(dev->hw_dev, ...
>>
>> Unfortunately the hw_dev value is only used by drivers that are doing
>> DMA. For most drivers this variable is going to be NULL so the output
>> is not going to work as expected.

They don't crash and still produce kernel logs, but replaces the device 
class and device name in the log entry with "(NULL device *)" or 
something like that.

> Sorry about that, I probably caused a lot of that.  As no one ever
> complained, odds are no one is using those drivers :)

Most of them seem to have from Ravishankar Karkala Mallikarjunayya.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
