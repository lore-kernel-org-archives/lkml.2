Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab0JUOiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:38:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44186 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0JUOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:38:24 -0400
Date: Thu, 21 Oct 2010 07:38:21 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [Patch] IBM Real-Time "SMI Free" mode driver -v7
Message-ID: <20101021143821.GB8754@lucy>
References: <20101005224718.GC4046@lucy>
 <20101021135429.GC22133@srcf.ucam.org>
 <20101021142319.GA8754@lucy>
 <20101021142523.GA23171@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101021142523.GA23171@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-Oct-2010 03:25 PM, Matthew Garrett wrote:
>On Thu, Oct 21, 2010 at 07:23:19AM -0700, Vernon Mauery wrote:
>> On 21-Oct-2010 02:54 PM, Matthew Garrett wrote:
>>> Applied, thanks. It'd be nice if we didn't have to rely on DMI,
>>> especially since enterprise customers often end up running later kernels
>>
>> I am not sure what you mean here by problems with DMI running later
>> kernels.
>
>Oops, sorry! I mean running on older kernels.

Do older kernels not have DMI support?  I would think that if an 
enterprise distribution wanted this driver they would likely already 
have DMI support backported as well.

Or they can work with me to find a way that works in that kernel.  I was 
thinking that in the current (and future) kernel, DMI was the best way 
to go.

>>> - is there any other way to determine that this is safe to load? Could
>>
>> I can't think of anything off the top of my head that would allow us to
>> ensure that this is only loaded on IBM systems.  DMI is pretty good
>> about that.
>
>I'd suggest using DMI to verify that it's an IBM, and perhaps also using
>DMI to check that it's a server or blade rather than a laptop or
>desktop. After that you could just check the ebda rather than having to
>have an entry for every specific machine.

I went for a better safe than sorry route.  Before I added the DMI 
checking I had some reports of this getting loaded on non-IBM hardware 
and it came up with some nasty error messages.  I figured since I knew 
exactly which platforms have support, I could just limit the driver to 
those.  Then there is the force parameter that allows a user to ignore 
the DMI data and try to load the driver anyway.

--Vernon
