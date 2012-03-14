Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2CNLAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:00:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34685 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932083Ab2CNLAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:00:06 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19qJCRuZVJqSJFU7EwUQ14FhZtHQN8mex0725Zuek
	tkSIJnmJuw5UsW
Message-ID: <4F607A18.8080004@gmx.de>
Date: Wed, 14 Mar 2012 10:59:36 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH] x86: export 'pcibios_enabled'
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>	<4F5FAE63.3090908@xenotime.net>	<4F5FE9AD.7000204@zytor.com> <20120314092955.2250a782@pyramind.ukuu.org.uk>
In-Reply-To: <20120314092955.2250a782@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing Wang YanQing, the author of the patch requiring it]

On 03/14/2012 09:29 AM, Alan Cox wrote:
>>>  
>>>  int pcibios_enabled;
>>> +EXPORT_SYMBOL(pcibios_enabled);
>>>  
>>>  /* According to the BIOS specification at:
>>>   * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could
>>
>> I would think this should be EXPORT_SYMBOL_GPL()... this seems like a
>> symbol with a very high likelihood to be abused in strange ways.
> 
> We don't need to expose it anyway
> 
> uvesafb could look for any PCI vga class device - which I suspect is
> what it *should* be doing ?

Would this really change depending on whether the page is NX-protected
or not?
Your suggestion sounds like it is about detecting whether there is any
graphic chip present or not while the patch is about fixing an oops
caused by NX-protection of the BIOS.


Best regards,

Florian Tobias Schandinat
