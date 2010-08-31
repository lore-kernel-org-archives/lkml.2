Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0HaCG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:06:59 -0400
Received: from talbot.seas.upenn.edu ([158.130.67.217]:35675 "EHLO
	talbot.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab0HaCG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:06:58 -0400
Message-ID: <4C7C639F.3040407@seas.upenn.edu>
Date: Mon, 30 Aug 2010 22:06:23 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz
CC: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 4/4] firmware sysfs node
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu> <1282798497-19791-5-git-send-email-rafi@seas.upenn.edu> <4C77AAE1.6050001@euromail.se> <20100827163436.GB13030@core.coreip.homeip.net>
In-Reply-To: <20100827163436.GB13030@core.coreip.homeip.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-08-31_01:2010-08-31,2010-08-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1008300207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/27/10 12:34, Dmitry Torokhov wrote:
> On Fri, Aug 27, 2010 at 02:09:05PM +0200, Henrik Rydberg wrote:
>> On 08/26/2010 06:54 AM, Rafi Rubin wrote:
>>
>>> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
>>> ---
>>>  drivers/hid/hid-ntrig.c |   21 +++++++++++++++++++++
>>>  1 files changed, 21 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
>>> index ab0ca7f..e341e88 100644
>>> --- a/drivers/hid/hid-ntrig.c
>>> +++ b/drivers/hid/hid-ntrig.c
>>> @@ -375,6 +375,26 @@ static ssize_t set_deactivate_slack(struct device *dev,
>>>  static DEVICE_ATTR(deactivate_slack, S_IWUSR | S_IRUGO, show_deactivate_slack,
>>>  		   set_deactivate_slack);
>>>  
>>> +static ssize_t show_firmware(struct device *dev,
>>> +			       struct device_attribute *attr,
>>> +			       char *buf)
>>> +{
>>> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>>> +	struct ntrig_data *nd = hid_get_drvdata(hdev);
>>> +
>>> +	if (!(nd->firmware_version[0] || nd->firmware_version[1] ||
>>> +	      nd->firmware_version[2] || nd->firmware_version[3]))
>>> +		return sprintf(buf, "Firmware version unavailable");
>>
>>
>> If this sysfs node should really be added (see EVIO), it is probably better if
>> it returns the same format for all devices. If all numbers are zero, that is
>> understandable also by someone reading the node.
>>
> 
> Yes, I think we should stick it into input_id and be done with it. Note
> that input_id is not only available via EVIOCGID ioctl but also already
> exported in sysfs.

The version in input_id is only 16 bits, whereas the ntrig version codes seem to
be 32 bits.  Actually I've only mapped 21 bits out of 64, but I figure the first
and last 8 are not actually part of the version, but that's still more than 16.

So, would you prefer that I increase the size of that field, or keep the
firmware version code separate?


Also does it make sense to have a provide a pretty printer in the kernel, or
should that be left to userspace?  The hardware returns a raw version code in
the form:
	1a08 a521

In the ntrig utilities and documentation the where firmware version is mentioned
it looks more like this:
	4.6.17.13.5

My intent was to make that second form more accessible to keep things simple for
users, who if they are checking that probably already have enough troubling them :)

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkx8Y5wACgkQwuRiAT9o608LGwCfYlJHAqxPXXt+wmEE42PWNsSG
d4kAnA6wdbMh8cj557ytMSYcVHFIowRp
=F3J9
-----END PGP SIGNATURE-----
