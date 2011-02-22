Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1BVXbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:31:12 -0500
Received: from smtp-out.google.com ([74.125.121.67]:43683 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1BVXbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X2uW/nkqLCg4wZ8upxTfBnuutR3uLqn6VHLhSrpeXS6zCcR2ac/ttT6yDksZmHVm9x
         IGu8kgQ86Cr24Bq9OAzA==
Message-ID: <4D644736.9050109@google.com>
Date: Tue, 22 Feb 2011 15:31:02 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>,
        David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com> <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com> <20110217215608.GA2451@kroah.com>
In-Reply-To: <20110217215608.GA2451@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/11 13:56, Greg KH wrote:
> Overall, this looks great, just a few minor comments below:
>
> On Thu, Feb 17, 2011 at 01:28:05PM -0800, Mike Waychison wrote:
>> +config DMI_SYSFS
>> +	tristate "DMI table support in sysfs"
>> +	depends on SYSFS&&  DMI
>> +	default X86
>
> Huh?  Default should be 'N' for any new feature, unless it keeps your
> machine from booting.
>
> I think you want this option to depend on X86 though, right?

Looks to be supported on ia64 as well, though I don't have any hardware 
to test this code on for that arch.  Tony: I think this DMI exporting 
code should just work on ia64 as all it is using is dmi_walk() and 
parsing the entries as returned as dmi_headers in the callback.  Does 
this sound sane to you?

>
>> +	help
>> +	  Say Y or M here to enable the exporting of the raw DMI table
>> +	  data via sysfs.  This is useful for consuming the data without
>> +	  requiring any access to /dev/mem at all.  Tables are found
>> +	  under /sys/firmware/dmi when this option is enabled and
>> +	  loaded.
>
> I just realized (due to other work I'm doing on a laptop) that we have a
> bunch of entries today in /sys/class/dmi/id which is a pointer to the
> dmi "device".
>
> Now I think this really is different (these are the raw DMI tables), but
> this doesn't have anything to do with that code, right?

Ya, it is similar, though the primary goal I have is to export these raw 
bytes.  The data comes from the same place, however the dmi-id code is 
just exporting the in-kernel copies of the strings parsed at boot.

These could probably be better exported under 
/sys/firmware/dmi/entries/[0123]-*/ files imo.

Mike Waychison
