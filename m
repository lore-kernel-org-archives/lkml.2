Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1BUWLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:11:08 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:64207 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1BUWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:11:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dQzZD3ZIKNYu6qslessOAGS+9UBb6nzrgRWGKpAbwsx7ENI04dXcf90BwUb3bBGDgp
         iKoMhBOgyogLjlPHdx8LnEbYCOR7T82gXvBHpmX0XC2/co2uZl4WMUe0JDmxczU/q5v1
         5AZN7s9MMPRlxfbVbvotckK/DGMK7fpwJOSvw=
Message-ID: <4D62E2F2.4060406@gmail.com>
Date: Mon, 21 Feb 2011 23:10:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl> <4D628521.8000205@linux.vnet.ibm.com> <4D629427.8020500@gmail.com> <4D629D03.90801@linux.vnet.ibm.com> <4D62CD93.3040206@gmail.com> <4D62D930.8060304@linux.vnet.ibm.com> <4D62DCBA.9050609@gmail.com> <4D62E221.7010104@linux.vnet.ibm.com>
In-Reply-To: <4D62E221.7010104@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 11:07 PM, Rajiv Andrade wrote:
> On 02/21/2011 06:44 PM, Jiri Slaby wrote:
>> On 02/21/2011 10:29 PM, Stefan Berger wrote:
>>> On 02/21/2011 03:39 PM, Jiri Slaby wrote:
>>>> On 02/21/2011 06:12 PM, Rajiv Andrade wrote:
>>>>> On 02/21/2011 01:34 PM, Jiri Slaby wrote:
>>>>>> There has to be another problem which caused my regression. And
>>>>>> since it
>>>>>> reports "Operation Timed out", the former default timeout values
>>>>>> worked
>>>>>> for me, the ones read from TPM do not.
>>>>> Yes, it's highly due inconsistent timeout values reported by the
>>>>> TPM as
>>>>> I mentioned, my working timeouts are:
>>>>> 3020000 4510000 181000000
>>>> 1000000 2000 150000
>>>>
>>>> Actually the first one from HW is 1. This is one is HZ after correction
>>>> in get_timeout. So perhaps it is in ms, yes.
>>> Following the specs, the timeouts are supposed to be in microseconds and
>>> ascending order for short, medium and long duration. Of course, if the
>>> device returns wrong timeouts, the command isn't going to succeed,
>>> failing the suspend in this case. Nevertheless, I think we need the
>>> patch I put in but at the same time we'll need a work-around for devices
>>> like this.
>> Yes, the patch is correct per se. But as it breaks bunch of machines it
>> cannot go in now. The rule is no regressions.
>>
>> After you have the workaround it should go into the next rc1 after that.
>> Do you plan to add a dmi-based quirk? Or, IOW do you want me to attach
>> dmidecode output? Or are you going to base it solely on TPM
>> manufacturer/version
> It's more reliable to base the workaround on the values themselves,
> instead of the TPM's ID, since
> we don't know whether other models will behave similarly.

As I wrote, you may base it on dmi data.

> It should be fine then to extend the existing workaround for short
> timeouts to the medium and long ones.

OK, but how will you guess the values?

regards,
-- 
js
