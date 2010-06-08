Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0FHNnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:43:01 -0400
Received: from core.signal11.us ([64.251.29.136]:52875 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab0FHNm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:42:59 -0400
Message-ID: <4C0E48DF.7000006@signal11.us>
Date: Tue, 08 Jun 2010 09:42:55 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Jiri Kosina <jkosina@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] HID: Add Support for Setting and Getting Feature  Reports  from hidraw
References: <1275969108-14948-1-git-send-email-alan@signal11.us> <20100608083226.2dac88d2.ospite@studenti.unina.it>
In-Reply-To: <20100608083226.2dac88d2.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Jun  8 09:42:59 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c0e48e3177368260621376
X-DSPAM-Factors: 27,
	reports, 0.01000,
	reports, 0.01000,
	Received*26+177, 0.01000,
	of, 0.01000,
	of, 0.01000,
	Received*ESMTP, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	use, 0.01000,
	use, 0.01000,
	report, 0.01000,
	report, 0.01000,
	From*<alan, 0.01000,
	Content-Type*8859+1, 0.01000,
	that, 0.01000,
	Subject*for, 0.01000,
	Received*core.signal11.us, 0.01000,
	Date*2010, 0.01000,
	in, 0.01000,
	in, 0.01000,
	does, 0.01000,
	From*Ott, 0.01000,
	Received*with, 0.01000,
	be, 0.01000,
	Received*id, 0.01000,
	Alan, 0.01000,
	Alan, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 02:32 AM, Antonio Ospite wrote:
> On Mon,  7 Jun 2010 23:51:48 -0400
> Alan Ott<alan@signal11.us>  wrote:
>
>    
>> Per the HID Specification, Feature reports must be sent and received on
>> the Configuration endpoint (EP 0) through the Set_Report/Get_Report
>> interfaces.  This patch adds two ioctls to hidraw to set and get feature
>> reports to and from the device.  Modifications were made to hidraw and
>> usbhid.
>>
>> New hidraw ioctls:
>>    HIDIOCSFEATURE - Perform a Set_Report transfer of a Feature report.
>>    HIDIOCGFEATURE - Perform a Get_Report transfer of a Feature report.
>>
>> Signed-off-by: Alan Ott<alan@signal11.us>
>> ---
>>      
> Thanks Alan, I am going to test this quite soon.
>
> TBH, when I was thinking about how to extend hidraw I thought we could
> have added a new report_type field to struct hidraw_report_descriptor,
> in order to re-use the HIDIOCGRDESC ioctl handler itself, adding then a
> HIDIOCSRDESC for setting the report. This looked cleaner to my eyes,
>    
Thanks for the feedback, Antonio. The HIDIOCGRDESC ioctl copies the 
existing descriptor from the hid_device structure. Since it does not 
initiate a Get_Report transfer, I'm not sure how much re-use there could 
have been using that method. In my estimation, a Set_Report/Get_Report 
was more similar to the call to write().

> but I didn't actually implement this, so I don't know if it was
> feasible, for instance one problem I didn't investigate further was
> about the default value of the aforementioned report_type field in
> order to keep the current behavior of HIDIOCGRDESC.
>    
I'm not sure what you mean here, as the report_type field is not part of 
hidraw_report_descriptor.

Thanks for testing my patch. Please let me know if you have problems 
with it.

Alan.

