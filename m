Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1D0WFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:05:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:63255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1D0WFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oyDFyUwfmiRXfZQUgY0LX/fhqr95YdsO/TNqURuDY7pYdpnUR/Yt4ReMekc5CSvGHZ
         7ogjrUPZ7Uhxe3qOmGgg==
Message-ID: <4DB89315.6070105@google.com>
Date: Wed, 27 Apr 2011 15:05:09 -0700
From: David Decotigny <decot@google.com>
Reply-To: david@decotigny.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv2 3/4] ethtool: Use the full 32 bit speed range in ethtool's
 set_settings
References: <1303001651-4074-1-git-send-email-decot@google.com>	 <1303929290-21037-4-git-send-email-decot@google.com> <1303932477.2875.130.camel@bwh-desktop>
In-Reply-To: <1303932477.2875.130.camel@bwh-desktop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On 04/27/11 12:27, Ben Hutchings wrote:
>> diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
>> index b13c6b0..f8d26bf 100644
>> --- a/drivers/net/tulip/de2104x.c
>> +++ b/drivers/net/tulip/de2104x.c
>> @@ -1549,10 +1549,11 @@ static int __de_set_settings(struct de_private *de, struct ethtool_cmd *ecmd)
>>  {
>>  	u32 new_media;
>>  	unsigned int media_lock;
>> +	u32 speed = ethtool_cmd_speed(ecmd);
>>  
>> -	if (ecmd->speed != SPEED_10 && ecmd->speed != 5 && ecmd->speed != 2)
>> +	if (speed != SPEED_10 && speed != 5 && speed != 2)
>>  		return -EINVAL;
>> -	if (de->de21040 && ecmd->speed == 2)
>> +	if (de->de21040 && speed == 2)
>>  		return -EINVAL;
>>  	if (ecmd->duplex != DUPLEX_HALF && ecmd->duplex != DUPLEX_FULL)
>>  		return -EINVAL;
> [...]
> 
> This implementation is absolute crap - it's using speed values as
> mnemonics for different physical ports!  Please change it to report and
> accept only speed = 10.  (Both get_settings and set_settings have to be
> changed at the same time.)

Well, I am really not sure about this. At first I thought you meant that
these non standard throughputs were a weird way to switch between
different ports because of some limitation in the ethtool API at the
time the driver was written. But looking at the history, this behavior
is there right from the very first revision of the driver checked in in
v2.5.0.9
(http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=b1507c9acd944c8703612c0e38ac580bf9064e8a),
and the ports could be switched the normal way with ecmd->port. So this
leads me to think that these speeds are actual speeds and make sense as
such, they are not a work-around over some ancient ethtool API
limitation. I have the patch ready but I would appreciate any feedback
on this.

Anyway, all your comments are really pertinent and ready to be sent.

Thank you!
Regards,
