Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2EOLUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:20:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab2EOLUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:20:43 -0400
Message-ID: <4FB23C09.7060300@suse.de>
Date: Tue, 15 May 2012 13:20:41 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
References: <1337079889-62380-1-git-send-email-hare@suse.de> <20120515111255.GJ32036@redhat.com>
In-Reply-To: <20120515111255.GJ32036@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 01:12 PM, Gleb Natapov wrote:
> Next time you resent an email say why you are doing it (wrong lkml
> address in this case).
> 
> On Tue, May 15, 2012 at 01:04:49PM +0200, Hannes Reinecke wrote:
>> The device_path_info_length for EDD 3.0 is 36, not 44.
>> Cf http://mbldr.sourceforge.net/specsedd30.pdf.
>>
> That's the wrong spec.
> 
Ah-ha.
Why?

>> This is a regression introduced by commit
>> 0c61227094b3ddaca2f847ee287c4a2e3762b5a2
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Cc: H. Peter Anvin <hpa@linux.intel.com>
>>
>> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
>> index e229576..09a77d5 100644
>> --- a/drivers/firmware/edd.c
>> +++ b/drivers/firmware/edd.c
>> @@ -545,8 +545,8 @@ edd_has_edd30(struct edd_device *edev)
>>  	}
>>  
>>  
>> -	/* We support only T13 spec */
>> -	if (info->params.device_path_info_length != 44)
> Here is the spec that code supports is spelled out, but you just replace
> the comment with pointer to the spec that the code does not support.
> 
Hmm? How so?

I have this EDD info:

# hexdump -C raw_data
00000000  1e 00 03 00 14 04 00 00  ff 00 00 00 3f 00 00 00
|............?...|
00000010  00 00 00 01 00 00 00 00  00 02 ff ff ff ff dd be
|................|
00000020  24 00 00 00 50 43 49 00  46 49 42 52 45 00 00 00
|$...PCI.FIBRE...|
00000030  07 00 00 00 00 00 00 00  50 01 43 80 01 3c 94 48
|........P.C..<.H|
00000040  01 c8 00 00 00 00 00 00  00 00                    |..........|

which used to be perfectly valid, contains an 'interface_type'
string, and a device path. All perfectly okay.
And, as mentioned, used to be displayed ok prior to the mentioned
commit.

So why do you claim we can't display it anymore?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
