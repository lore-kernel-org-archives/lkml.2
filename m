Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0JMTH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:07:27 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:57296 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0JMTHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:07:25 -0400
X-IronPort-AV: E=Sophos;i="4.57,326,1283745600"; 
   d="scan'208";a="23313961"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "gregkh@suse.de" <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Drivers <Drivers@analog.com>
Date: Wed, 13 Oct 2010 20:07:19 +0100
Subject: RE: linux-next: Tree for October 13 (staging/iio)
Thread-Topic: linux-next: Tree for October 13 (staging/iio)
Thread-Index: Actq9afEHaL52ONOT8GT8lEkqYLVsAAEvqbw
Message-ID: <544AC56F16B56944AEC3BD4E3D59177130943738AE@LIMKCMBX1.ad.analog.com>
References: <20101013154522.7b087a20.sfr@canb.auug.org.au>
 <20101013094117.530baa63.randy.dunlap@oracle.com>
In-Reply-To: <20101013094117.530baa63.randy.dunlap@oracle.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote on 2010-10-13:
> On Wed, 13 Oct 2010 15:45:22 +1100 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20101012:
>
>
> drivers/staging/iio/adc/ad7476.h:62: note: expected 'struct device *'
> but argument is of type 'struct ad7476_state *'
> drivers/staging/iio/adc/ad7476_core.c:48: error: too few arguments to
> function 'ad7476_scan_from_ring'

Thanks!

That's due to an old prototype active when CONFIG_IIO_RING_BUFFER is not set.
I'll fix that.

> drivers/staging/iio/adc/ad7476_core.c: At top level:
> drivers/staging/iio/adc/ad7476_core.c:102: error:
> 'IIO_SCAN_EL_TYPE_UNSIGNED' undeclared here (not in a function)

Jonathan,

Do we really need to guard the entire ring_generic.h header with

#ifdef CONFIG_IIO_RING_BUFFER
...

Some of these might be used, even when CONFIG_IIO_RING_BUFFER is not set.
Or do we really need CONFIG_IIO_RING_BUFFER at all.
Why not always provide it?

>
> config is attached.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your
> code ***

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


