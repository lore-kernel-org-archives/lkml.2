Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab0IGXUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:20:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58790 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751175Ab0IGXUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:20:36 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/6K0BNVNT6Q/xY4jrsXMjOoerl1vh2M7WDOQ6sdD
	TOciz7GWUwWxdD
Message-ID: <4C86C8BD.2080703@gmx.de>
Date: Wed, 08 Sep 2010 01:20:29 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] viafb: add interface for output device configuration
References: <1283813290-3384-1-git-send-email-FlorianSchandinat@gmx.de> <20100907155301.d97c85c7.akpm@linux-foundation.org>
In-Reply-To: <20100907155301.d97c85c7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> On Mon,  6 Sep 2010 22:48:10 +0000
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> viafb: add interface for output device configuration
>>
>> This patch extends the proc entry to contain a possibility to view and
>> change the output devices for each IGA. This is useful for debugging
>> output problems as it provides a reliable way to query which low level
>> devices are active after VIAs output device configuration nightmare
>> happended. It's as well suitable for daily use as one can change the
>> output configuration on the fly for example to connect a projector.
>> At the moment it's still unstable. The reason is that we have to handle
>> a bunch of undocumented output devices (those without a proper name) and
>> that this patch is the first step to collect and verify the needed
>> information. Basically the only configuration change that is expected to
>> work at the moment is switching output devices between IGA1 and IGA2.
>>
>> ...
>>  
>> +u32 via_parse_odev(char *input, char **end)
>> +{
>> +	char *ptr = input;
>> +	u32 odev = 0;
>> +	bool next = true;
>> +	int i, len;
>> +
>> +	while (next) {
>> +		next = false;
>> +		for (i = 0; i < ARRAY_SIZE(device_mapping); i++) {
>> +			len = strlen(device_mapping[i].name);
>> +			if (!strncmp(ptr, device_mapping[i].name, len)) {
>> +				odev |= device_mapping[i].device;
>> +				ptr += len;
>> +				if (*ptr == ',') {
>> +					ptr++;
>> +					next = true;
>> +				}
>> +			}
>> +		}
>> +	}
>> +
>> +	*end = ptr;
>> +	return odev;
>> +}
> 
> So people must decrypt the above code
> 
>> +		iga1_entry = proc_mkdir("iga1", viafb_entry);
>> +		shared->iga1_proc_entry = iga1_entry;
>> +		proc_create("output_devices", 0, iga1_entry,
>> +			&viafb_iga1_odev_proc_fops);
>> +		iga2_entry = proc_mkdir("iga2", viafb_entry);
>> +		shared->iga2_proc_entry = iga2_entry;
>> +		proc_create("output_devices", 0, iga2_entry,
>> +			&viafb_iga2_odev_proc_fops);
>>  	}
> 
> to work out what to write into these?
> 
> Can we have a wee bit of documetnation, please?  At least in the
> changelog, but Documentation/fb/viafb.txt would be a better place.

Of course. I just wanted to make sure that the interface is sane and reasonable 
and improve the code to do the right thing at least in most of the cases before 
writing proper documentation for it. I hope that I can achieve the first with 
this e-mail and for the later I just prepared a patch which I'm testing at the 
moment. If there are no objections against this interface I hope I can send a 
complete patch series including this patch, major improvements and documentation 
within a week.


Thanks,

Florian Tobias Schandinat
