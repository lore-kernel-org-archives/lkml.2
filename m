Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1DGL1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:27:48 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:45930 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1DGL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:27:47 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9DA00A.3030700@cam.ac.uk>
Date: Thu, 07 Apr 2011 12:29:14 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Sonny Rao <sonnyrao@chromium.org>
CC: linux-pm@lists.linux-foundation.org, bleung@chromium.org,
        snanda@chromium.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Phillip Kurtenbach <pkurtenbach@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Enable async suspend/resume on industrial IO devices
References: <1302057915-13549-1-git-send-email-sonnyrao@chromium.org> <4D9C477E.4050400@cam.ac.uk> <BANLkTikWBU-uW6xKwNt+zrS0JbDPOzdd0w@mail.gmail.com>
In-Reply-To: <BANLkTikWBU-uW6xKwNt+zrS0JbDPOzdd0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/11 23:47, Sonny Rao wrote:
> On Wed, Apr 6, 2011 at 3:59 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>> On 04/06/11 03:45, Sonny Rao wrote:
>>> Industrial I/O devices can sometimes take a long time to resume,
>>> allowing them to be asynchronus saves 50ms on one light sensor
>>>
>> Hi Sonny,
>>
>> cc'd linux-iio
>>
>> I'm not particularly familiar with this.  Are there any disadvantages?
>> I just wonder if it would be better to push this into individual drivers
>> rather than the core?
> 
> Yeah we could do it that way too, I sent out a similar patch for i2c
> and people were asking if it was entirely safe.  It sounds like it may
> depend on dependencies between devices.
> 
> Do you know if any of the devices in iio have inter-device dependencies?
> I was under the impression they were mostly stand-alone sensors that
> ordinarily wouldn't, but I haven't tried to audit all of them or anything.
Mostly I think is the key word here.  Right now I don't think we have anything
that would have a problem, but putting something like that in the core is
liable to bite sometime in the future.  For now at least I think I'd prefer
to see it in an individual driver.
