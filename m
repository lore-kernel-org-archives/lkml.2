Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2LJVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:16:29 -0500
Received: from mx.exactcode.de ([85.10.202.90]:47951 "EHLO mx.exactcode.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab2LJVQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:16:27 -0500
X-Greylist: delayed 1906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 16:16:27 EST
References: <20121210145134.GA2097@hedwig.ini.cmu.edu> <20121210190905.GA24927@roeck-us.net> <20121210195414.GA642@polaris.bitmath.org> <4BC00520-E08A-43D0-AA2B-EA8154F3D160@suse.de>
Mime-Version: 1.0 (1.0)
In-Reply-To: <4BC00520-E08A-43D0-AA2B-EA8154F3D160@suse.de>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <4017A6C6-3074-44A5-AAAC-F4246946F151@exactcode.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <groeck-dsl@sbcglobal.net>,
        "Gabriel L. Somlo" <somlo@cmu.edu>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (10A525)
From: Rene Rebe <rene@exactcode.com>
Subject: Re: [PATCH] applesmc: add sysfs file to report OSK
Date: Mon, 10 Dec 2012 21:43:50 +0100
To: Alexander Graf <agraf@suse.de>
X-Spam-Score: -1.0 (-)
X-Spam-Report: Spam detection software, running on the system "exactcode.de", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On 10.12.2012, at 21:19, Alexander Graf <agraf@suse.de> wrote:
	> > On 10.12.2012, at 20:54, Henrik Rydberg wrote: > >> Hi Guenter, >> >>>
	On Mon, Dec 10, 2012 at 09:51:35AM -0500, Gabriel L. Somlo wrote: >>>> The
	AppleSMC contains two char[32] keys, OSK0 and OSK1, which are not >>>> reported
	in the key count and index by default. These keys are used by >>>> the OS
	X boot sequence, and normally don't matter when running Linux. >>>> >>>>
	This patch creates a sysfs entry which reports the value of these keys >>>>
	as an ASCII string, to help emulators (such as QEMU) load OS X when >>>>
	running on genuine Apple hardware. >>>> >>>> Signed-off-by: Gabriel L. Somlo
	<somlo@cmu.edu> >>>> --- >>>> >>>> For extra context: To boot OS X as a guest,
	QEMU must (among others) >>>> emulate the AppleSMC. To boot successfully,
	OS X insists on querying >>>> the (emulated) SMC for the value of OSK0 and
	OSK1. Currently, these >>>> values must be supplied on the QEMU command line
	as >>>> >>>> -device applesmc,osk="...concatenated values of OSK0 and OSK1..."
	>>>> >>>> With the availability of /sys/devices/platform/applesmc.768/osk,
	the >>>> emulated QEMU AppleSMC could acquire this string directly from the
	>>>> (Apple-manufactured) host machine. >>> Hmm ... this is a non-hwmon attribute
	which doesn't really belong into hwmon >>> in the first place ... like several
	other attributes in the same driver. >>> >>> So I'll leave it up to the maintainer
	to decide if we should accept it. Henrik ? >> >> Indeed, the reaons against
	this patch are too many. I was just about >> to reply with the below: >>
	>> Gabriel, >> >> The OSK string seems constant accross machines, which renders
	the >> patch rather pointless, no? And even if the OSK differs between a
	>> couple of machines, the emulator could easily handle it gracefully. > >
	The point is that the return value of the OSK is a copyrighted string, we
	can not include in any other layer. The only way to make this legally savvy
	is to read the key from the host. > >> >> There are also some technical issues
	with the patch below, to keep in >> mind for future [...] 
	Content analysis details:   (-1.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.5 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4983]
	0.5 MIME_QP_LONG_LINE      RAW: Quoted-printable line longer than 76 chars
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10.12.2012, at 21:19, Alexander Graf <agraf@suse.de> wrote:

> 
> On 10.12.2012, at 20:54, Henrik Rydberg wrote:
> 
>> Hi Guenter,
>> 
>>> On Mon, Dec 10, 2012 at 09:51:35AM -0500, Gabriel L. Somlo wrote:
>>>> The AppleSMC contains two char[32] keys, OSK0 and OSK1, which are not
>>>> reported in the key count and index by default. These keys are used by
>>>> the OS X boot sequence, and normally don't matter when running Linux.
>>>> 
>>>> This patch creates a sysfs entry which reports the value of these keys
>>>> as an ASCII string, to help emulators (such as QEMU) load OS X when
>>>> running on genuine Apple hardware.
>>>> 
>>>> Signed-off-by: Gabriel L. Somlo <somlo@cmu.edu>
>>>> ---
>>>> 
>>>> For extra context: To boot OS X as a guest, QEMU must (among others)
>>>> emulate the AppleSMC. To boot successfully, OS X insists on querying
>>>> the (emulated) SMC for the value of OSK0 and OSK1. Currently, these
>>>> values must be supplied on the QEMU command line as
>>>> 
>>>> -device applesmc,osk="...concatenated values of OSK0 and OSK1..."
>>>> 
>>>> With the availability of /sys/devices/platform/applesmc.768/osk, the
>>>> emulated QEMU AppleSMC could acquire this string directly from the
>>>> (Apple-manufactured) host machine.
>>> Hmm ... this is a non-hwmon attribute which doesn't really belong into hwmon
>>> in the first place ... like several other attributes in the same driver.
>>> 
>>> So I'll leave it up to the maintainer to decide if we should accept it. Henrik ?
>> 
>> Indeed, the reaons against this patch are too many. I was just about
>> to reply with the below:
>> 
>> Gabriel,
>> 
>> The OSK string seems constant accross machines, which renders the
>> patch rather pointless, no? And even if the OSK differs between a
>> couple of machines, the emulator could easily handle it gracefully.
> 
> The point is that the return value of the OSK is a copyrighted string, we can not include in any other layer. The only way to make this legally savvy is to read the key from the host.
> 
>> 
>> There are also some technical issues with the patch below, to keep in
>> mind for future submissions.
> 
> Sigh - most of the comments below go back to earlier review from me. He basically had a version almost exactly like what you're asking him to do :). Funny how code style taste differs.

And this is exactly the reason why I'm less and less motivated to waste my lifetime with upstream work ...

> Alex
> 
>> 
>>> drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
>>> 1 files changed, 18 insertions(+), 0 deletions(-)
>>> 
>>> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
>>> index b41baff..0c7cc71 100644
>>> --- a/drivers/hwmon/applesmc.c
>>> +++ b/drivers/hwmon/applesmc.c
>>> @@ -1013,6 +1013,23 @@ static ssize_t applesmc_key_at_index_store(struct device *dev,
>>>    return count;
>>> }
>>> 
>>> +static ssize_t applesmc_osk_show(struct device *dev,
>>> +                struct device_attribute *attr, char *sysfsbuf)
>>> +{
>>> +    int fail;
>> 
>> All other functions use 'ret' here...
>> 
>>> +
>>> +    mutex_lock(&smcreg.mutex);
>>> +    fail = read_smc(APPLESMC_READ_CMD, "OSK0", sysfsbuf, 32) ||
>>> +           read_smc(APPLESMC_READ_CMD, "OSK1", sysfsbuf + 32, 32);
>> 
>> The read function should propagate error messages, i.e., keep the
>> return values here. And please read to buffers instead.
>> 
>>> +    mutex_unlock(&smcreg.mutex);
>>> +    if (fail)
>>> +        return -1;
>> 
>> Return error here.
>> 
>>> +
>>> +    sysfsbuf[64] = '\n';
>>> +    sysfsbuf[65] = '\0';
>>> +    return 65;
>> 
>> A snprintf here, please.
>> 
>>> +}
>>> +
>>> static struct led_classdev applesmc_backlight = {
>>>    .name            = "smc::kbd_backlight",
>>>    .default_trigger    = "nand-disk",
>>> @@ -1027,6 +1044,7 @@ static struct applesmc_node_group info_group[] = {
>>>    { "key_at_index_type", applesmc_key_at_index_type_show },
>>>    { "key_at_index_data_length", applesmc_key_at_index_data_length_show },
>>>    { "key_at_index_data", applesmc_key_at_index_read_show },
>>> +    { "osk", applesmc_osk_show },
>> 
>> Unfortunately this is not a good place to put random things going
>> forward.
>> 
>>>    { }
>>> };
>>> 
>>> -- 
>>> 1.7.7.6
>> 
>> Given the above issues together with the weak rationale for the patch
>> in the first place, this patch will not be applied.
>> 
>> Thanks.
>> Henrik
> 
