Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1LVR4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:56:14 -0500
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:60304 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1LVR4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:56:12 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Dec 2011 11:55:56 -0600
Subject: Re: Driver core support for early platform devices
Thread-Topic: Driver core support for early platform devices
Thread-Index: AczA0vVrZlAEiulvTp63rQuHtYDz5Q==
Message-ID: <99F3E881-FB9E-4D49-9A91-793FDD04795D@boeing.com>
References: <0282FD61-7E73-45CE-8EC8-32BF411C7619@boeing.com>
 <20111222174521.GA29144@suse.de>
In-Reply-To: <20111222174521.GA29144@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 22, 2011, at 12:45, Greg KH wrote:
> On Thu, Dec 22, 2011 at 11:15:06AM -0600, Moffett, Kyle D wrote:
>> Hi,
>> 
>> I'm tinkering with some improvements to the way that OpenPIC/MPIC are
>> detected and loaded on PowerPC platforms, and it seems like I am trying
>> to use the driver model before it is fully initialized.
>> 
>> In particular, it seems like it should be possible to simply declare an
>> OpenPIC in the device-tree and have it automatically bound to a platform
>> driver declaring the right OpenFirmware match strings.
>> 
>> Unfortunately, it needs to be bound by init_IRQ() time, while the driver
>> model does not get initialized until much later (after the scheduler is
>> up and running).
>> 
>> As far as I can tell, there seem to be 2 possible approaches to making
>> that possible:
>> 
>> (1) Split the driver-model initialization into "early" and "late" phases
>>    so that drivers can be registered and devices probed very early on
>>    and then replay the necessary scheduler-dependent things after the
>>    system is mostly started up (IE: devtmpfs, etc).
> 
> We already have that today with the "early_platform*" functions, right?
> Will those work for you, or do you need this for a bus you are creating
> and not using the platform bus?

Well, I can't figure out how "early_platform" is actually supposed to
integrate with the platform bus itself.  It seems designed mostly for
drivers like "earlyprintk" et. al. for which loading is controlled by
a kernel parameter.

Specifically, I don't see any "early_platform" logic to match devices in
the OF device-tree based on the driver "of_match" parameters, just based
on text strings in early_param().

Furthermore, if I register an "early_platform" device, it seems to get
unregistered when the normal driver model is brought up, instead of
being sucked in and promoted to a normal platform_device.  That code is
pretty poorly documented and only used in a couple places right now,
though, so it's possible I am misreading it.

Cheers,
Kyle Moffett
