Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0KBQGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:06:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61641 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0KBQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ibfGlg2j/PAWHQW+BXwmKUU/n5f/4TjRZDnNs182xRbUXafk1nX3maIBwAK8zPV7Dp
         TOr+LojIr7sUVBi5gZuz2zLpW5aClvJNypTBezfwZzEEMrId58lp00VerB/tSksBMqCb
         cbXsp72ofVge89YK3aK0lGhF7UbjdOsW7vXLs=
MIME-Version: 1.0
In-Reply-To: <1288712259.7326.4.camel@Joe-Laptop>
References: <1288711861-3625-1-git-send-email-audun.hoem@gmail.com>
	<1288712259.7326.4.camel@Joe-Laptop>
Date: Tue, 2 Nov 2010 17:06:11 +0100
Message-ID: <AANLkTinPDYSV0Xh27AiQNzytsifqXm4Mxa_KwYG8iNb+@mail.gmail.com>
Subject: Re: [PATCH] staging: frontier: alphatrack: fixed coding style issues
From: Audun Hoem <audun.hoem@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/10, Joe Perches <joe@perches.com> wrote:
> On Tue, 2010-11-02 at 16:31 +0100, Audun Hoem wrote:
>> Cleaned up a macro definition and another simple style warning.
>> Signed-off-by: Audun Hoem <audun.hoem@gmail.com>
>> ---
>>  drivers/staging/frontier/alphatrack.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/frontier/alphatrack.c
>> b/drivers/staging/frontier/alphatrack.c
>> index ef7fbf8..6e3bd73 100644
>> --- a/drivers/staging/frontier/alphatrack.c
>> +++ b/drivers/staging/frontier/alphatrack.c
>> @@ -88,8 +88,11 @@ MODULE_SUPPORTED_DEVICE("Frontier Designs Alphatrack
>> Control Surface");
>>  static int debug = ALPHATRACK_DEBUG;
>>
>>  /* Use our own dbg macro */
>> -#define dbg_info(dev, format, arg...) do \
>> -    { if (debug) dev_info(dev , format , ## arg); } while (0)
>> +#define dbg_info(dev, format, arg...) \
>> +do { \
>> +	if (debug) \
>> +		dev_info(dev , format , ## arg); \
>
> There is no need for the spaces before commas.
>
> gcc 2.xx required a space before a comma with a trailing ##arg,
> but that compiler version is no longer supported.
>
> This should be:
> 	dev_info(dev, format, ##arg);
>
> though I think using dev_dbg and getting rid of the dbg_info
> macro is better.
>

I was planning to remove the patch in a later patch, which I at the
time thought was necessary, but in light of this checkpatch fault, I
guess I could have just pushed it in this one.
>> +} while (0)
>>
>>  #define alphatrack_ocmd_info(dev, cmd, format, arg...)
>>
>> @@ -769,7 +772,7 @@ static int usb_alphatrack_probe(struct usb_interface
>> *intf,
>>  	}
>>
>>  	dev->write_buffer =
>> -	    kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);
>> +	    kmalloc(sizeof(struct alphatrack_ocmd) *true_size, GFP_KERNEL);
>
> Not an improvement.
>
> If checkpatch warns about this, it's a checkpatch defect.
Interesting. Apparently it mistook the multiplication operator for the
unary * operator. May take a look at that perl script later.
