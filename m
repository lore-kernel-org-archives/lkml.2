Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0H2T6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 15:58:19 -0400
Received: from talbot.seas.upenn.edu ([158.130.67.217]:52091 "EHLO
	talbot.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0H2T6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 15:58:17 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Aug 2010 15:58:17 EDT
Message-ID: <4C7ABA64.50005@seas.upenn.edu>
Date: Sun, 29 Aug 2010 15:52:04 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 1/4] Adding documention
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu> <1282798497-19791-2-git-send-email-rafi@seas.upenn.edu> <4C77AA45.4030805@euromail.se>
In-Reply-To: <4C77AA45.4030805@euromail.se>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-08-29_06:2010-08-29,2010-08-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1008290141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/27/10 08:06, Henrik Rydberg wrote:
> On 08/26/2010 06:54 AM, Rafi Rubin wrote:
> 
> [...]
> 
>> +Parameters
> 
>> +----------
>> +
>> +Note: values set at load time are global and will apply to all applicable
>> +devices.  Adjusting parameters with sysfs will override the load time values,
>> +but only for that one device.
>> +
>> +The following parameters are used to configure filters to reduce noise:
>> +
>> +activate_slack		number of fingers to ignore before processing events
>> +
>> +activation_height	size threshold to activate immediately
>> +activation_width
>> +
>> +min_height		size threshold bellow which fingers are ignored
>> +min_width		both to decide activation and during activity
>> +
>> +deactivate_slack	the number of "no contact" frames to ignore before
>> +			propagating the end of activity events
>> +
>> +When the last finger is removed from the device, it sends a number of empty
>> +frames.  By holding off on deactivation for a few frames we can tolerate false
>> +erroneous disconnects, where the sensor may mistakenly not detect a finger that
>> +is still present.  Thus deactivate_slack addresses problems where a users might
>> +see breaks in lines during drawing, or drop an object during a long drag.
> 
> 
> Without contact tracking, it is hard to imagine activation filtering to work
> properly. I would advocate to remove this functionality from the driver, and add
> it in userspace instead.
> 
> Henrik

I don't think its quite time to remove these filters.  There still isn't a
proper replacement that's readily accessible to most users.  From what I've
heard many still use the wacom driver to support touch in X.

Tracking only helps if you increase the activation slack to more than 1 contact
(the current default), and only if you assume the you will see ghosts span
multiple frames in two different locations, which may be even less likely than
seeing a ghost in one spot for two frames.

Maybe in a few more months or another year, it will make more sense to remove
the filters from this driver.  In the mean time, is it really preferable to
leave them undocumented?

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkx6umIACgkQwuRiAT9o608sTQCg38F+0v0PSA+jqKSy84yDlVRW
df8AoNWxO6zpnpY1Wvgu8xUrnH2uvFaB
=uEW9
-----END PGP SIGNATURE-----
