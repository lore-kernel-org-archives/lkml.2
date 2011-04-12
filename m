Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1DLTXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1DLTXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:23:05 -0400
Message-ID: <4DA4A68A.2050604@redhat.com>
Date: Tue, 12 Apr 2011 15:22:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, mstowe@redhat.com, dnelson@redhat.com,
        tony.luck@intel.com
Subject: Re: [PATCH]: mce: don't print "human readable" message for corrected
 errors
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com> <20110412185842.GB9891@liondog.tnic>
In-Reply-To: <20110412185842.GB9891@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/2011 02:58 PM, Borislav Petkov wrote:
> On Tue, Apr 12, 2011 at 01:44:05PM -0400, Prarit Bhargava wrote:
>   
>> Don't display the "human readable" warning for correctable errors in mce.
>> There is no need for this information to be displayed.
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>     
> Why not? This way you turn reporting of _ALL_ correctable MCEs
> completely off and some users would actually like to run them through
> mcelog on Intel.
>   

I may be reading the code wrong ... but in the case of the
default_decode_mce() callback there is *no* additional output displayed
for correctable MCEs -- so the message is AFAICT useless.

ie) all you see on the console log is

[Hardware Error]: Machine check events logged

^^^ this notifies the user that something happened with MCE

[Hardware Error]: No human readable MCE decoding support on this CPU type.

^^^ this is purely informational and unnecessary

[Hardware Error]: Run the message through 'mcelog --ascii' to decode.

^^^ this makes absolutely no sense.  There is no message to decode.

You won't see this in the case of the amd-edac because it has it's own
callback.

P.
