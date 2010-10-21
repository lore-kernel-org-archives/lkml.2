Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0JUPJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:09:36 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54014 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0JUPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:09:34 -0400
Date: Thu, 21 Oct 2010 08:09:28 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [Patch] IBM Real-Time "SMI Free" mode driver -v7
Message-ID: <20101021150928.GC8754@lucy>
References: <20101005224718.GC4046@lucy>
 <20101021135429.GC22133@srcf.ucam.org>
 <20101021142319.GA8754@lucy>
 <20101021142523.GA23171@srcf.ucam.org>
 <20101021143821.GB8754@lucy>
 <20101021144234.GA23552@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101021144234.GA23552@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-Oct-2010 03:42 PM, Matthew Garrett wrote:
>On Thu, Oct 21, 2010 at 07:38:21AM -0700, Vernon Mauery wrote:
>> On 21-Oct-2010 03:25 PM, Matthew Garrett wrote:
>>> Oops, sorry! I mean running on older kernels.
>>
>> Do older kernels not have DMI support?  I would think that if an
>> enterprise distribution wanted this driver they would likely already
>> have DMI support backported as well.
>
>I mean that they may run the current driver on newer hardware that isn't
>in the DMI table, and that may be the only thing preventing it from
>working.
>
>>> I'd suggest using DMI to verify that it's an IBM, and perhaps also using
>>> DMI to check that it's a server or blade rather than a laptop or
>>> desktop. After that you could just check the ebda rather than having to
>>> have an entry for every specific machine.
>>
>> I went for a better safe than sorry route.  Before I added the DMI
>> checking I had some reports of this getting loaded on non-IBM hardware
>> and it came up with some nasty error messages.  I figured since I knew
>> exactly which platforms have support, I could just limit the driver to
>> those.  Then there is the force parameter that allows a user to ignore
>> the DMI data and try to load the driver anyway.
>
>It's preferable to have the driver be able to support future hardware
>built to the same spec without having to add extra IDs. It's easy to
>make sure that you're loading on an IBM server - are there any of these
>that have the _RTL_ header but will break?

No, if it has the _RTL_ header it should be fine.  I was more concerned 
about the driver trying to map the EBDA and reading through it on 
non-ibm platforms, so I guess just a check to see that it is IBM should 
be sufficient.  Let me get a patch that does that.

--Vernon
